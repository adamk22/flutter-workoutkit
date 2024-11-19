// Export all classes
export 'classes/index.dart';
export 'enums/index.dart';
export 'workout_preview_button.dart';
export 'sampleWorkouts/index.dart';

import 'package:flutter_workoutkit/classes/workouts/custom_workout.class.dart';

import 'workoutkit_platform_interface.dart';

class Workoutkit {
  Future<String?> getPlatformVersion() {
    return WorkoutkitPlatform.instance.getPlatformVersion();
  }

  Future<void> createCustomWorkout(CustomWorkout customWorkout) {
    Map<String, dynamic> customWorkoutJson = customWorkout.toJson();
    return WorkoutkitPlatform.instance.createCustomWorkout(customWorkoutJson);
  }

  Future<void> requestHealthPermissions() {
    return WorkoutkitPlatform.instance.requestHealthPermissions();
  }
}
