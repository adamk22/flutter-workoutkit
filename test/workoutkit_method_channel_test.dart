import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_workoutkit/flutter_workoutkit.dart';
import 'package:flutter_workoutkit/src/workoutkit_method_channel.dart';

import 'models/test_helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final platform = MethodChannelWorkoutkit();
  const channel = MethodChannel('workoutkit');
  final calls = <MethodCall>[];
  late Object? Function(MethodCall call) respond;

  final workout = Workout.fromJson(loadFixture('custom_workout.json'));
  final scheduledJson = <Object?, Object?>{
    'workout': loadFixture('pacer_workout.json')
      ..['id'] = '11111111-2222-3333-4444-555555555555',
    'date': {'year': 2026, 'month': 10, 'day': 12, 'hour': 7, 'minute': 30},
    'complete': false,
  };

  setUp(() {
    calls.clear();
    respond = (_) => null;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
      calls.add(call);
      return respond(call);
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    respond = (_) => '42';
    expect(await platform.getPlatformVersion(), '42');
  });

  test('validateWorkout sends the workout JSON and parses the result',
      () async {
    respond = (_) => {
          'isValid': false,
          'issues': ['bad goal']
        };
    final result = await platform.validateWorkout(workout);
    expect(calls.single.method, 'validate');
    expect(
        normalize(calls.single.arguments), loadFixture('custom_workout.json'));
    expect(result.isValid, isFalse);
    expect(result.issues, ['bad goal']);
  });

  test('exportWorkout / importWorkout', () async {
    final bytes = Uint8List.fromList([1, 2, 3]);
    respond = (call) => call.method == 'exportPlan'
        ? bytes
        : loadFixture('swim_bike_run_workout.json');

    expect(await platform.exportWorkout(workout), bytes);
    expect(calls.last.method, 'exportPlan');

    final imported = await platform.importWorkout(bytes);
    expect(calls.last.method, 'importPlan');
    expect(calls.last.arguments, bytes);
    expect(imported, isA<SwimBikeRunWorkout>());
  });

  group('scheduler', () {
    test('isSupported / authorization / max count', () async {
      respond = (call) => switch (call.method) {
            'scheduler.isSupported' => true,
            'scheduler.authorizationState' => 'notDetermined',
            'scheduler.requestAuthorization' => 'authorized',
            'scheduler.maxAllowedScheduledWorkoutCount' => 15,
            _ => null,
          };
      expect(await platform.schedulerIsSupported(), isTrue);
      expect(await platform.schedulerAuthorizationState(),
          SchedulerAuthorizationState.notDetermined);
      expect(await platform.schedulerRequestAuthorization(),
          SchedulerAuthorizationState.authorized);
      expect(await platform.schedulerMaxAllowedScheduledWorkoutCount(), 15);
    });

    test('schedule sends local date components', () async {
      respond = (_) => scheduledJson;
      final scheduled = await platform.schedulerSchedule(
          workout, DateTime(2026, 10, 12, 7, 30, 45));
      expect(calls.single.method, 'scheduler.schedule');
      final args = calls.single.arguments as Map;
      expect(args['date'],
          {'year': 2026, 'month': 10, 'day': 12, 'hour': 7, 'minute': 30});
      expect(normalize(args['workout']), loadFixture('custom_workout.json'));
      expect(scheduled.id, '11111111-2222-3333-4444-555555555555');
      expect(scheduled.date, DateTime(2026, 10, 12, 7, 30));
      expect(scheduled.workout, isA<PacerWorkout>());
    });

    test('scheduledWorkouts parses the list', () async {
      respond = (_) => [scheduledJson];
      final list = await platform.schedulerScheduledWorkouts();
      expect(list, hasLength(1));
      expect(list.single.complete, isFalse);
    });

    test('remove / markComplete / removeAll', () async {
      final date = DateTime(2026, 10, 12, 7, 30);
      await platform.schedulerRemove('abc', date);
      await platform.schedulerMarkComplete('abc', date);
      await platform.schedulerRemoveAll();
      expect(calls.map((c) => c.method), [
        'scheduler.remove',
        'scheduler.markComplete',
        'scheduler.removeAll',
      ]);
      expect(calls.first.arguments, {
        'id': 'abc',
        'date': {'year': 2026, 'month': 10, 'day': 12, 'hour': 7, 'minute': 30},
      });
    });
  });

  test('PlatformException is mapped to WorkoutkitException', () async {
    respond = (_) => throw PlatformException(
        code: WorkoutkitErrorCode.unsupportedOS, message: 'needs iOS 18');
    await expectLater(
      platform.validateWorkout(workout),
      throwsA(isA<WorkoutkitException>()
          .having((e) => e.code, 'code', 'UNSUPPORTED_OS')
          .having((e) => e.message, 'message', 'needs iOS 18')),
    );
  });
}
