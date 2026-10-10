import 'package:flutter_workoutkit/flutter_workoutkit.dart';
import 'package:flutter_workoutkit/src/utils/json.dart';

/// A workout with a single goal, e.g. run 5 km or swim 30 minutes.
class SingleGoalWorkout extends Workout {
  /// The goal of the workout.
  final WorkoutGoal goal;

  /// The swimming location. Required if [activityType] is swimming.
  final WorkoutSwimmingLocationType? swimmingLocation;

  /// The location. Required unless [activityType] is swimming.
  final WorkoutLocationType? location;

  /// The activity type of the workout.
  final WorkoutActivityType activityType;

  /// Creates a new single goal workout.
  ///
  /// Throws an [ArgumentError] when [location]/[swimmingLocation] don't match
  /// [activityType].
  SingleGoalWorkout({
    required this.activityType,
    required this.goal,
    this.location,
    this.swimmingLocation,
    super.id,
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
    final json = super.toJson()
      ..addAll({
        'activityType': activityType.name,
        'goal': goal.toJson(),
      });
    putIfNotNull(json, 'location', location?.name);
    putIfNotNull(json, 'swimmingLocation', swimmingLocation?.name);
    return json;
  }

  /// Returns a copy with the given fields replaced.
  SingleGoalWorkout copyWith({
    WorkoutActivityType? activityType,
    WorkoutGoal? goal,
    WorkoutLocationType? location,
    WorkoutSwimmingLocationType? swimmingLocation,
    String? id,
  }) {
    return SingleGoalWorkout(
      activityType: activityType ?? this.activityType,
      goal: goal ?? this.goal,
      location: location ?? this.location,
      swimmingLocation: swimmingLocation ?? this.swimmingLocation,
      id: id ?? this.id,
    );
  }

  /// Creates a new single goal workout from a JSON object.
  static SingleGoalWorkout fromJson(Map<String, dynamic> json) {
    return SingleGoalWorkout(
      id: json['id'] as String?,
      activityType: WorkoutActivityType.fromString(json['activityType']),
      goal: WorkoutGoal.fromJson(asJsonMap(json['goal'])),
      location: json['location'] != null
          ? WorkoutLocationType.values.byName(json['location'] as String)
          : null,
      swimmingLocation: json['swimmingLocation'] != null
          ? WorkoutSwimmingLocationType.values
              .byName(json['swimmingLocation'] as String)
          : null,
    );
  }
}
