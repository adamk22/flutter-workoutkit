// Export all classes
export 'classes/index.dart';
export 'enums/index.dart';

import 'package:workoutkit/classes/CustomWorkout.class.dart';

import 'workoutkit_platform_interface.dart';

class Workoutkit {
  Future<String?> getPlatformVersion() {
    return WorkoutkitPlatform.instance.getPlatformVersion();
  }

  Future<void> createCustomWorkout(CustomWorkout customWorkout) {
    Map<String, dynamic> customWorkoutJson = customWorkout.toJson();
    return WorkoutkitPlatform.instance.createCustomWorkout(customWorkoutJson);
  }
}
