import 'package:flutter_workoutkit/workoutkit.dart';

class WorkoutGoal {
  final WorkoutGoalType type;
  final double? targetValue;
  final Duration? targetDuration;
  final WorkoutGoalUnit? unit;

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

  Map<String, dynamic> toJson() {
    return {
      'type': type.toString().split('.').last,
      'targetValue': targetValue,
      'targetDuration': targetDuration?.inSeconds,
      'unit': unit?.toString().split('.').last,
    };
  }
}
