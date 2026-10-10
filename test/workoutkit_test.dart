import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_workoutkit/flutter_workoutkit.dart';
import 'package:flutter_workoutkit/src/workoutkit_method_channel.dart';
import 'package:flutter_workoutkit/src/workoutkit_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockWorkoutkitPlatform
    with MockPlatformInterfaceMixin
    implements WorkoutkitPlatform {
  final scheduled = <ScheduledWorkout>[];

  @override
  Future<String?> getPlatformVersion() async => '42';

  @override
  Future<void> requestHealthPermissions() async {}

  @override
  Future<bool> hasHealthPermissions() async => true;

  @override
  Future<WorkoutValidationResult> validateWorkout(Workout workout) async =>
      const WorkoutValidationResult(isValid: true, issues: []);

  @override
  Future<Uint8List> exportWorkout(Workout workout) async =>
      Uint8List.fromList([7]);

  @override
  Future<Workout> importWorkout(Uint8List data) async => sampleCustomWorkout;

  @override
  Future<bool> schedulerIsSupported() async => true;

  @override
  Future<SchedulerAuthorizationState> schedulerAuthorizationState() async =>
      SchedulerAuthorizationState.authorized;

  @override
  Future<SchedulerAuthorizationState> schedulerRequestAuthorization() async =>
      SchedulerAuthorizationState.authorized;

  @override
  Future<int> schedulerMaxAllowedScheduledWorkoutCount() async => 15;

  @override
  Future<ScheduledWorkout> schedulerSchedule(
      Workout workout, DateTime date) async {
    final s = ScheduledWorkout(
      workout: Workout.fromJson({...workout.toJson(), 'id': 'plan-1'}),
      date: date,
    );
    scheduled.add(s);
    return s;
  }

  @override
  Future<List<ScheduledWorkout>> schedulerScheduledWorkouts() async =>
      scheduled;

  @override
  Future<void> schedulerRemove(String id, DateTime date) async =>
      scheduled.removeWhere((s) => s.id == id && s.date == date);

  @override
  Future<void> schedulerMarkComplete(String id, DateTime date) async {}

  @override
  Future<void> schedulerRemoveAll() async => scheduled.clear();
}

void main() {
  final WorkoutkitPlatform initialPlatform = WorkoutkitPlatform.instance;

  test('$MethodChannelWorkoutkit is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelWorkoutkit>());
  });

  group('with a mock platform', () {
    late MockWorkoutkitPlatform fake;

    setUp(() {
      fake = MockWorkoutkitPlatform();
      WorkoutkitPlatform.instance = fake;
    });

    test('Workoutkit forwards to the platform', () async {
      expect(await Workoutkit.getPlatformVersion(), '42');
      expect((await Workoutkit.validate(sampleCustomWorkout)).isValid, isTrue);
      expect(await Workoutkit.exportWorkout(sampleCustomWorkout), [7]);
      expect(
          await Workoutkit.importWorkout(Uint8List(0)), isA<CustomWorkout>());
    });

    test('WorkoutScheduler schedules, lists and removes', () async {
      expect(await WorkoutScheduler.isSupported(), isTrue);
      expect(await WorkoutScheduler.requestAuthorization(),
          SchedulerAuthorizationState.authorized);
      final s = await WorkoutScheduler.schedule(
          samplePacerMinutesWorkout, DateTime(2026, 1, 1, 8));
      expect(s.id, 'plan-1');
      expect(await WorkoutScheduler.scheduledWorkouts(), hasLength(1));
      await WorkoutScheduler.remove(s);
      expect(await WorkoutScheduler.scheduledWorkouts(), isEmpty);
    });
  });
}
