import 'package:flutter_workoutkit/flutter_workoutkit.dart';
import 'package:flutter_workoutkit/src/utils/json.dart';

/// The goal of a workout or step.
///
/// Prefer the named constructors, e.g. `WorkoutGoal.distance(5, WorkoutGoalUnit.kilometers)`.
class WorkoutGoal {
  /// The type of the goal.
  final WorkoutGoalType type;

  /// The target value. Required for distance, energy and
  /// pool swim distance with time goals.
  final double? targetValue;

  /// The target duration. Required for time and pool swim distance with time
  /// goals.
  final Duration? targetDuration;

  /// The unit of [targetValue] (distance or energy), or the display unit of
  /// [targetDuration] for time goals (defaults to minutes).
  final WorkoutGoalUnit? unit;

  /// The display unit of [targetDuration] for pool swim distance with time
  /// goals (defaults to minutes).
  final WorkoutGoalUnit? durationUnit;

  /// Creates a new workout goal.
  const WorkoutGoal({
    required this.type,
    this.targetValue,
    this.targetDuration,
    this.unit,
    this.durationUnit,
  }) : assert(
          (type == WorkoutGoalType.distance && targetValue != null) ||
              (type == WorkoutGoalType.time && targetDuration != null) ||
              (type == WorkoutGoalType.energy && targetValue != null) ||
              (type == WorkoutGoalType.poolSwimDistanceWithTime &&
                  targetValue != null &&
                  targetDuration != null &&
                  unit != null) ||
              type == WorkoutGoalType.open,
          'targetValue is required for distance and energy goals, '
          'targetDuration for time goals, and targetValue, unit and '
          'targetDuration for pool swim distance with time goals',
        );

  /// A goal-less (open) workout or step.
  const WorkoutGoal.open() : this(type: WorkoutGoalType.open);

  /// Complete [value] in [unit] (meters, kilometers, miles or yards).
  const WorkoutGoal.distance(double value, WorkoutGoalUnit unit)
      : this(type: WorkoutGoalType.distance, targetValue: value, unit: unit);

  /// Complete [duration], displayed in [unit] (seconds, minutes or hours).
  const WorkoutGoal.time(
    Duration duration, {
    WorkoutGoalUnit unit = WorkoutGoalUnit.minutes,
  }) : this(type: WorkoutGoalType.time, targetDuration: duration, unit: unit);

  /// Burn [value] of active energy. Note that [WorkoutGoalUnit.calories] are
  /// small calories; most apps mean [WorkoutGoalUnit.kilocalories].
  const WorkoutGoal.energy(
    double value, {
    WorkoutGoalUnit unit = WorkoutGoalUnit.kilocalories,
  }) : this(type: WorkoutGoalType.energy, targetValue: value, unit: unit);

  /// Swim [distance] in a pool within [duration]. Requires iOS 18.0+.
  const WorkoutGoal.poolSwimDistanceWithTime({
    required double distance,
    required WorkoutGoalUnit distanceUnit,
    required Duration duration,
    WorkoutGoalUnit durationUnit = WorkoutGoalUnit.minutes,
  }) : this(
          type: WorkoutGoalType.poolSwimDistanceWithTime,
          targetValue: distance,
          unit: distanceUnit,
          targetDuration: duration,
          durationUnit: durationUnit,
        );

  /// Converts the workout goal to a JSON object.
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{'type': type.name};
    putIfNotNull(json, 'targetValue', targetValue);
    putIfNotNull(
      json,
      'targetDuration',
      targetDuration == null ? null : durationToSeconds(targetDuration!),
    );
    putIfNotNull(json, 'unit', unit?.name);
    putIfNotNull(json, 'durationUnit', durationUnit?.name);
    return json;
  }

  /// Creates a new workout goal from a JSON object.
  static WorkoutGoal fromJson(Map<String, dynamic> json) {
    return WorkoutGoal(
      type: WorkoutGoalType.fromString(json['type'] as String),
      targetValue: asDoubleOrNull(json['targetValue']),
      targetDuration: json['targetDuration'] != null
          ? asSecondsDuration(json['targetDuration'])
          : null,
      unit: json['unit'] != null
          ? WorkoutGoalUnit.fromString(json['unit'] as String)
          : null,
      durationUnit: json['durationUnit'] != null
          ? WorkoutGoalUnit.fromString(json['durationUnit'] as String)
          : null,
    );
  }
}
