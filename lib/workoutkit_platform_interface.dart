import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'workoutkit_method_channel.dart';

abstract class WorkoutkitPlatform extends PlatformInterface {
  /// Constructs a WorkoutkitPlatform.
  WorkoutkitPlatform() : super(token: _token);

  static final Object _token = Object();

  static WorkoutkitPlatform _instance = MethodChannelWorkoutkit();

  /// The default instance of [WorkoutkitPlatform] to use.
  ///
  /// Defaults to [MethodChannelWorkoutkit].
  static WorkoutkitPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [WorkoutkitPlatform] when
  /// they register themselves.
  static set instance(WorkoutkitPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<void> createCustomWorkout(Map<String, dynamic> customWorkoutJson) {
    throw UnimplementedError('createCustomWorkout() has not been implemented.');
  }

  Future<void> createSingleGoalWorkout(
      Map<String, dynamic> singleGoalWorkoutJson) {
    throw UnimplementedError(
        'createSingleGoalWorkout() has not been implemented.');
  }
}
