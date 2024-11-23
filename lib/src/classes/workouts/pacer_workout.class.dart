import 'package:flutter_workoutkit/workoutkit.dart';

/// Represents a pacer workout
class PacerWorkout extends Workout {
  /// The activity type of the workout
  final WorkoutActivityType activityType;

  /// The location type of the workout
  final WorkoutLocationType location;

  /// The target value of the workout
  final double targetValue;

  /// The unit of the target value
  final GoalDistanceUnits targetValueUnit;

  /// The target duration of the workout
  final Duration targetDuration;

  /// The unit of the target duration
  final GoalTimeUnits targetDurationUnit;

  /// Creates a new pacer workout
  PacerWorkout({
    required this.activityType,
    required this.location,
    required this.targetValue,
    required this.targetValueUnit,
    required this.targetDuration,
    required this.targetDurationUnit,
  }) : super(workoutType: WorkoutType.pacerWorkout);

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'activityType': activityType.toString().split('.').last,
      'location': location.toString().split('.').last,
      'targetValue': targetValue,
      'targetValueUnit': targetValueUnit.toString().split('.').last,
      'targetDuration': targetDuration.inSeconds,
      'targetDurationUnit': targetDurationUnit.toString().split('.').last,
    };
  }

  /// Creates a new pacer workout from a JSON object
  static PacerWorkout fromJson(Map<String, dynamic> json) {
    return PacerWorkout(
      activityType: WorkoutActivityType.values
          .firstWhere((e) => e.name == json['activityType']),
      location: WorkoutLocationType.values
          .firstWhere((e) => e.name == json['location']),
      targetValue: json['targetValue'],
      targetValueUnit: GoalDistanceUnits.values
          .firstWhere((e) => e.name == json['targetValueUnit']),
      targetDuration: Duration(seconds: json['targetDuration']),
      targetDurationUnit: GoalTimeUnits.values
          .firstWhere((e) => e.name == json['targetDurationUnit']),
    );
  }
}
