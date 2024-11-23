import 'package:flutter_workoutkit/workoutkit.dart';

/// Represents a single goal workout
class SingleGoalWorkout extends Workout {
  /// The goal of the workout
  final WorkoutGoal goal;

  /// The swimming location of the workout (optional)
  /// swimmingLocation is required if the activity type is swimming
  final WorkoutSwimmingLocationType? swimmingLocation;

  /// The location of the workout (optional)
  /// location is required if the activity type is not swimming
  final WorkoutLocationType? location;

  /// The activity type of the workout
  final WorkoutActivityType activityType;

  /// Creates a new single goal workout
  SingleGoalWorkout({
    required this.activityType,
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

  /// Creates a new single goal workout from a JSON object
  static SingleGoalWorkout fromJson(Map<String, dynamic> json) {
    return SingleGoalWorkout(
      activityType: WorkoutActivityType.values
          .firstWhere((e) => e.name == json['activityType']),
      goal: WorkoutGoal.fromJson(json['goal'] as Map<String, dynamic>),
      location: json['location'] != null
          ? WorkoutLocationType.values
              .firstWhere((e) => e.name == json['location'])
          : null,
      swimmingLocation: json['swimmingLocation'] != null
          ? WorkoutSwimmingLocationType.values
              .firstWhere((e) => e.name == json['swimmingLocation'])
          : null,
    );
  }
}
