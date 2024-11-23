import 'package:flutter_workoutkit/workoutkit.dart';

/// Represents a workout goal
class WorkoutGoal {
  /// The type of the goal
  final WorkoutGoalType type;

  /// The target value of the goal
  /// targetValue is required if the goal type is distance or energy
  final double? targetValue;

  /// The target duration of the goal
  /// targetDuration is required if the goal type is time
  final Duration? targetDuration;

  /// The unit of the goal
  /// unit is required if the goal type is distance or energy
  final WorkoutGoalUnit? unit;

  /// Creates a new workout goal
  const WorkoutGoal({
    required this.type,
    this.targetValue,
    this.targetDuration,
    this.unit,
  }) : assert(
          (type == WorkoutGoalType.distance && targetValue != null) ||
              (type == WorkoutGoalType.time && targetDuration != null) ||
              (type == WorkoutGoalType.energy && targetValue != null) ||
              type == WorkoutGoalType.open,
          'targetValue is required for distance type, targetDuration is required for time type, targetValue is required for energy type',
        );

  /// Converts the workout goal to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'type': type.toString().split('.').last,
      'targetValue': targetValue,
      'targetDuration': targetDuration?.inSeconds,
      'unit': unit?.toString().split('.').last,
    };
  }

  /// Creates a new workout goal from a JSON object
  static WorkoutGoal fromJson(Map<String, dynamic> json) {
    return WorkoutGoal(
      type: WorkoutGoalType.values
          .firstWhere((e) => e.toString().split('.').last == json['type']),
      targetValue: json['targetValue'] as double?,
      targetDuration: json['targetDuration'] != null
          ? Duration(seconds: json['targetDuration'] as int)
          : null,
      unit: json['unit'] != null
          ? WorkoutGoalUnit.values
              .firstWhere((e) => e.toString().split('.').last == json['unit'])
          : null,
    );
  }
}
