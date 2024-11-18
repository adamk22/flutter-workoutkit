import 'package:flutter_workoutkit/classes/index.dart';
import 'package:flutter_workoutkit/enums/index.dart';

class SingleGoalWorkout extends Workout {
  final WorkoutGoal goal;
  final WorkoutSwimmingLocationType? swimmingLocation;
  final WorkoutLocationType? location;

  SingleGoalWorkout({
    required super.activityType,
    required this.goal,
    this.location,
    this.swimmingLocation,
  }) : super(workoutType: WorkoutType.singleGoalWorkout) {
    if (activityType == WorkoutActivityType.swimming) {
      if (swimmingLocation == null || location != null) {
        throw ArgumentError(
          'Swimming workouts require swimmingLocation and must not have location set',
        );
      }
    } else {
      if (location == null || swimmingLocation != null) {
        throw ArgumentError(
          'Non-swimming workouts require location and must not have swimmingLocation set',
        );
      }
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json['activityType'] = activityType.toString().split('.').last;
    json['workoutType'] = workoutType.toString().split('.').last;
    json['goal'] = goal.toJson();
    if (location != null) {
      json['location'] = location.toString().split('.').last;
    }
    if (swimmingLocation != null) {
      json['swimmingLocation'] = swimmingLocation.toString().split('.').last;
    }
    return json;
  }
}
