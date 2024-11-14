import 'package:flutter_test/flutter_test.dart';
import 'package:workoutkit/workoutkit.dart';
import 'package:workoutkit/workoutkit_platform_interface.dart';
import 'package:workoutkit/workoutkit_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockWorkoutkitPlatform
    with MockPlatformInterfaceMixin
    implements WorkoutkitPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<void> createCustomWorkout(Map<String, dynamic> customWorkoutJson) =>
      Future.value();

  @override
  Future<void> createSingleGoalWorkout(
          Map<String, dynamic> singleGoalWorkoutJson) =>
      Future.value();
}

void main() {
  final WorkoutkitPlatform initialPlatform = WorkoutkitPlatform.instance;

  test('$MethodChannelWorkoutkit is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelWorkoutkit>());
  });

  test('getPlatformVersion', () async {
    Workoutkit workoutkitPlugin = Workoutkit();
    MockWorkoutkitPlatform fakePlatform = MockWorkoutkitPlatform();
    WorkoutkitPlatform.instance = fakePlatform;

    expect(await workoutkitPlugin.getPlatformVersion(), '42');
  });
}
