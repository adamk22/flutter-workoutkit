// Export Workout Parts
export 'classes/workoutParts/interval_block.class.dart';
export 'classes/workoutParts/interval_step.class.dart';
export 'classes/workoutParts/workoutAlerts/index.dart';
export 'classes/workoutParts/workout_goal.class.dart';
export 'classes/workoutParts/workout_step.class.dart';
export 'classes/workoutParts/multisport_activity.class.dart';

// Export Workouts
export 'classes/workouts/custom_workout.class.dart';
export 'classes/workouts/pacer_workout.class.dart';
export 'classes/workouts/single_goal_workout.class.dart';
export 'classes/workouts/swim_bike_run_workout.class.dart';
export 'classes/workouts/base_workout.class.dart';

// Export Enums
export 'enums/goal_types.enum.dart';
export 'enums/workout_type.enum.dart';
export 'enums/multisport_activity.enum.dart';
export 'enums/workout_activity_type.enum.dart';
export 'enums/workout_location_type.enum.dart';
export 'enums/workout_swimming_location_type.enum.dart';
export 'enums/workout_alert_type.enum.dart';
export 'enums/workout_alert_metric.enum.dart';
export 'enums/unit_speed.enum.dart';

// Export Core Components
export 'workout_preview_button.dart';

// Export Sample Workouts
export 'sampleWorkouts/sample_custom_workout.dart';
export 'sampleWorkouts/sample_single_goal_workout.dart';
export 'sampleWorkouts/sample_pacer_workout.dart';
export 'sampleWorkouts/sample_swim_bik_run_workout.dart';

import 'workoutkit_platform_interface.dart';

class Workoutkit {
  Future<String?> getPlatformVersion() {
    return WorkoutkitPlatform.instance.getPlatformVersion();
  }

  Future<void> requestHealthPermissions() {
    return WorkoutkitPlatform.instance.requestHealthPermissions();
  }
}
