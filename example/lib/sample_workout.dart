import 'package:flutter_workoutkit/flutter_workoutkit.dart';

/// The sample workout from the README.
final CustomWorkout sampleWorkout = CustomWorkout(
  activityType: WorkoutActivityType.running,
  location: WorkoutLocationType.outdoor,
  displayName: "[SAMPLE] 5K Training Run",
  warmup: WorkoutStep(
    alert: HeartRateZoneAlert(zone: 1),
    goal: const WorkoutGoal(
      type: WorkoutGoalType.time,
      targetDuration: Duration(minutes: 5),
      unit: WorkoutGoalUnit.minutes,
    ),
  ),
  blocks: [
    IntervalBlock(
      iterations: 4,
      steps: [
        IntervalStep(
          alert: HeartRateZoneAlert(zone: 3),
          purpose: IntervalStepPurpose.work,
          goal: const WorkoutGoal(
            type: WorkoutGoalType.time,
            targetDuration: Duration(minutes: 5),
            unit: WorkoutGoalUnit.minutes,
          ),
        ),
      ],
    ),
    IntervalBlock(
      iterations: 4,
      steps: [
        IntervalStep(
          alert: HeartRateZoneAlert(zone: 3),
          purpose: IntervalStepPurpose.work,
          goal: const WorkoutGoal(
            type: WorkoutGoalType.time,
            targetDuration: Duration(minutes: 2),
            unit: WorkoutGoalUnit.minutes,
          ),
        ),
        IntervalStep(
          alert: HeartRateZoneAlert(zone: 2),
          purpose: IntervalStepPurpose.recovery,
          goal: const WorkoutGoal(
            type: WorkoutGoalType.time,
            targetDuration: Duration(minutes: 2),
            unit: WorkoutGoalUnit.minutes,
          ),
        ),
      ],
    ),
    IntervalBlock(
      iterations: 1,
      steps: [
        IntervalStep(
          alert: HeartRateZoneAlert(zone: 2),
          purpose: IntervalStepPurpose.recovery,
          goal: const WorkoutGoal(
            type: WorkoutGoalType.time,
            targetDuration: Duration(minutes: 5),
            unit: WorkoutGoalUnit.minutes,
          ),
        ),
      ],
    ),
  ],
  cooldown: WorkoutStep(
    alert: HeartRateZoneAlert(zone: 1),
    goal: const WorkoutGoal(
      type: WorkoutGoalType.time,
      targetDuration: Duration(minutes: 5),
      unit: WorkoutGoalUnit.minutes,
    ),
  ),
);
