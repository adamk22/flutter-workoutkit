import 'package:flutter_workoutkit/flutter_workoutkit.dart';
import 'package:flutter_workoutkit/src/utils/json.dart';

/// Cover a distance in a target time; the Watch paces the user.
class PacerWorkout extends Workout {
  /// The activity type of the workout.
  final WorkoutActivityType activityType;

  /// The location type of the workout.
  final WorkoutLocationType location;

  /// The distance to cover.
  final double targetValue;

  /// The unit of [targetValue].
  final GoalDistanceUnits targetValueUnit;

  /// The time to cover the distance in.
  final Duration targetDuration;

  /// The unit [targetDuration] is displayed in.
  final GoalTimeUnits targetDurationUnit;

  /// Creates a new pacer workout.
  PacerWorkout({
    required this.activityType,
    required this.location,
    required this.targetValue,
    required this.targetValueUnit,
    required this.targetDuration,
    required this.targetDurationUnit,
    super.id,
  }) : super(workoutType: WorkoutType.pacerWorkout);

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'activityType': activityType.name,
      'location': location.name,
      'targetValue': targetValue,
      'targetValueUnit': targetValueUnit.name,
      'targetDuration': durationToSeconds(targetDuration),
      'targetDurationUnit': targetDurationUnit.name,
    };
  }

  /// Returns a copy with the given fields replaced.
  PacerWorkout copyWith({
    WorkoutActivityType? activityType,
    WorkoutLocationType? location,
    double? targetValue,
    GoalDistanceUnits? targetValueUnit,
    Duration? targetDuration,
    GoalTimeUnits? targetDurationUnit,
    String? id,
  }) {
    return PacerWorkout(
      activityType: activityType ?? this.activityType,
      location: location ?? this.location,
      targetValue: targetValue ?? this.targetValue,
      targetValueUnit: targetValueUnit ?? this.targetValueUnit,
      targetDuration: targetDuration ?? this.targetDuration,
      targetDurationUnit: targetDurationUnit ?? this.targetDurationUnit,
      id: id ?? this.id,
    );
  }

  /// Creates a new pacer workout from a JSON object.
  static PacerWorkout fromJson(Map<String, dynamic> json) {
    return PacerWorkout(
      id: json['id'] as String?,
      activityType: WorkoutActivityType.fromString(json['activityType']),
      location: WorkoutLocationType.values.byName(json['location'] as String),
      targetValue: asDouble(json['targetValue']),
      targetValueUnit: GoalDistanceUnits.fromString(json['targetValueUnit']),
      targetDuration: asSecondsDuration(json['targetDuration']),
      targetDurationUnit: GoalTimeUnits.fromString(json['targetDurationUnit']),
    );
  }
}
