import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_workoutkit/flutter_workoutkit.dart';
import 'package:flutter_workoutkit/src/workoutkit_platform_interface.dart';
import 'package:flutter_workoutkit/src/workoutkit_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockWorkoutkitPlatform
    with MockPlatformInterfaceMixin
    implements WorkoutkitPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<void> requestHealthPermissions() => Future.value();

  @override
  Future<bool> hasHealthPermissions() => Future.value(true);
}

void main() {
  final WorkoutkitPlatform initialPlatform = WorkoutkitPlatform.instance;

  test('$MethodChannelWorkoutkit is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelWorkoutkit>());
  });

  test('getPlatformVersion', () async {
    MockWorkoutkitPlatform fakePlatform = MockWorkoutkitPlatform();
    WorkoutkitPlatform.instance = fakePlatform;

    expect(await Workoutkit.getPlatformVersion(), '42');
  });
}
