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
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type.toString().split('.').last,
      'targetValue': targetValue,
      'targetDuration': targetDuration?.inSeconds,
      'unit': unit?.toString().split('.').last,
    };
  }
}

enum WorkoutGoalType {
  distance,
  time,
  calories,
  custom,
}

enum WorkoutGoalUnit {
  kilometers,
  miles,
  meters,
  yards,
  minutes,
  hours,
  seconds,
  calories,
  kilocalories,
  custom,
}
