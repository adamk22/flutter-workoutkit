export 'src/classes/index.dart';
export 'src/enums/index.dart';
export 'src/samples/index.dart';
export 'src/workout_preview_button.dart';

import 'src/workoutkit_platform_interface.dart';

/// The main class for the workoutkit package
class Workoutkit {
  /// Gets the platform version
  static Future<String?> getPlatformVersion() {
    return WorkoutkitPlatform.instance.getPlatformVersion();
  }

  /// Requests health permissions
  static Future<void> requestHealthPermissions() {
    return WorkoutkitPlatform.instance.requestHealthPermissions();
  }

  /// Gets the health permissions boolean status
  static Future<bool> hasHealthPermissions() {
    return WorkoutkitPlatform.instance.hasHealthPermissions();
  }
}
