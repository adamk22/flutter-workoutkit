export 'src/classes/index.dart';
export 'src/enums/index.dart';
export 'src/samples/index.dart';
export 'src/workout_preview_button.dart';

import 'src/workoutkit_platform_interface.dart';

class Workoutkit {
  Future<String?> getPlatformVersion() {
    return WorkoutkitPlatform.instance.getPlatformVersion();
  }

  Future<void> requestHealthPermissions() {
    return WorkoutkitPlatform.instance.requestHealthPermissions();
  }
}
