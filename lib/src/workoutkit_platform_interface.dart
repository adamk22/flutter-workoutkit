import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'workoutkit_method_channel.dart';

/// Abstract class for the workoutkit platform
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

  /// Gets the platform version
  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  /// Requests health permissions
  Future<void> requestHealthPermissions() {
    throw UnimplementedError(
        'requestHealthPermissions() has not been implemented.');
  }

  /// Gets the health permissions status
  Future<bool> hasHealthPermissions() {
    throw UnimplementedError(
        'hasHealthPermissions() has not been implemented.');
  }
}
