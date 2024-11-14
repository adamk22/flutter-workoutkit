import 'package:workoutkit/classes/workoutParts/WorkoutGoal.class.dart';
import 'package:workoutkit/enums/WorkoutSwimmingLocationType.enum.dart';

import 'Workout.class.dart';

class SingleGoalWorkout extends Workout {
  final WorkoutGoal goal;
  final WorkoutSwimmingLocationType? swimmingLocation;

  SingleGoalWorkout({
    required super.activityType,
    required super.location,
    required this.goal,
    required this.swimmingLocation,
  });
}
