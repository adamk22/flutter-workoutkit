import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_workoutkit/workoutkit_method_channel.dart';

import 'mockCustomWorkout.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelWorkoutkit platform = MethodChannelWorkoutkit();
  const MethodChannel channel = MethodChannel('workoutkit');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });

  test('createCustomWorkout', () async {
    await platform.createCustomWorkout(mockCustomWorkout.toJson());
  });
}
