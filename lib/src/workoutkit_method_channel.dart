import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'workoutkit_platform_interface.dart';

/// An implementation of [WorkoutkitPlatform] that uses method channels.
class MethodChannelWorkoutkit extends WorkoutkitPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('workoutkit');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<void> requestHealthPermissions() async {
    await methodChannel.invokeMethod<void>('requestHealthPermissions');
  }

  @override
  Future<bool> hasHealthPermissions() async {
    final status =
        await methodChannel.invokeMethod<bool>('hasHealthPermissions');
    return status ?? false;
  }
}
