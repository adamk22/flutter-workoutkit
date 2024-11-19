import 'package:flutter_workoutkit/workoutkit.dart';

final CustomWorkout mockSpeedCyclingWorkout = CustomWorkout(
  activityType: WorkoutActivityType.cycling,
  location: WorkoutLocationType.outdoor,
  displayName: "Test Speed Cycling",
  warmup: WorkoutStep(
    alert: HeartRateZoneAlert(zone: 1),
    goal: const WorkoutGoal(
      type: WorkoutGoalType.time,
      targetDuration: Duration(minutes: 10),
      unit: WorkoutGoalUnit.minutes,
    ),
  ),
  blocks: [
    IntervalBlock(
      type: IntervalBlockType.work,
      iterations: 1,
      steps: [
        IntervalStep(
          alert: SpeedRangeAlert(
            lowerBound: 28,
            upperBound: 32,
            unitSpeed: UnitSpeed.kilometersPerHour,
            metric: WorkoutAlertMetric.average,
          ),
          purpose: IntervalStepPurpose.work,
          goal: const WorkoutGoal(
            type: WorkoutGoalType.distance,
            targetValue: 24,
            unit: WorkoutGoalUnit.kilometers,
          ),
        ),
      ],
    ),
  ],
  cooldown: WorkoutStep(
    alert: HeartRateZoneAlert(zone: 1),
    goal: const WorkoutGoal(
      type: WorkoutGoalType.time,
      targetDuration: Duration(minutes: 10),
      unit: WorkoutGoalUnit.minutes,
    ),
  ),
);

final CustomWorkout mockCustomWorkout = CustomWorkout(
  activityType: WorkoutActivityType.running,
  location: WorkoutLocationType.outdoor,
  displayName: "Test Timed Run",
  warmup: WorkoutStep(
    alert: HeartRateZoneAlert(
      zone: 1,
    ),
    goal: const WorkoutGoal(
      type: WorkoutGoalType.time,
      targetDuration: Duration(minutes: 5),
      unit: WorkoutGoalUnit.minutes,
    ),
  ),
  blocks: [
    IntervalBlock(
      type: IntervalBlockType.work,
      iterations: 4,
      steps: [
        IntervalStep(
          alert: HeartRateZoneAlert(zone: 2),
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
      type: IntervalBlockType.workRecovery,
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
          alert: HeartRateZoneAlert(zone: 1),
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
      type: IntervalBlockType.recovery,
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

final CustomWorkout mock10kTrainingRun = CustomWorkout(
  activityType: WorkoutActivityType.running,
  location: WorkoutLocationType.outdoor,
  displayName: "10K Training Run",
  warmup: WorkoutStep(
    alert: HeartRateRangeAlert(lowerBound: 86, upperBound: 120),
    goal: const WorkoutGoal(
      type: WorkoutGoalType.time,
      targetDuration: Duration(minutes: 10),
      unit: WorkoutGoalUnit.minutes,
    ),
  ),
  blocks: [
    IntervalBlock(
      type: IntervalBlockType.work,
      iterations: 1,
      steps: [
        IntervalStep(
          alert: HeartRateRangeAlert(lowerBound: 136, upperBound: 156),
          purpose: IntervalStepPurpose.work,
          goal: const WorkoutGoal(
            type: WorkoutGoalType.distance,
            targetValue: 5000,
            unit: WorkoutGoalUnit.meters,
          ),
        ),
      ],
    ),
    IntervalBlock(
      type: IntervalBlockType.recovery,
      iterations: 1,
      steps: [
        IntervalStep(
          alert: HeartRateRangeAlert(lowerBound: 90, upperBound: 120),
          purpose: IntervalStepPurpose.recovery,
          goal: const WorkoutGoal(
            type: WorkoutGoalType.time,
            targetDuration: Duration(minutes: 5),
            unit: WorkoutGoalUnit.minutes,
          ),
        ),
      ],
    ),
    IntervalBlock(
      type: IntervalBlockType.work,
      iterations: 1,
      steps: [
        IntervalStep(
          alert: HeartRateRangeAlert(lowerBound: 136, upperBound: 156),
          purpose: IntervalStepPurpose.work,
          goal: const WorkoutGoal(
            type: WorkoutGoalType.distance,
            targetValue: 5,
            unit: WorkoutGoalUnit.kilometers,
          ),
        ),
      ],
    ),
  ],
  cooldown: WorkoutStep(
    alert: HeartRateRangeAlert(lowerBound: 86, upperBound: 120),
    goal: const WorkoutGoal(
      type: WorkoutGoalType.time,
      targetDuration: Duration(minutes: 5),
      unit: WorkoutGoalUnit.minutes,
    ),
  ),
);

final CustomWorkout mock21kmTrainingRun = CustomWorkout(
  activityType: WorkoutActivityType.running,
  location: WorkoutLocationType.outdoor,
  displayName: "21k Stepped Run",
  warmup: WorkoutStep(
    displayName: "5 min warmup",
    alert: HeartRateZoneAlert(zone: 1),
    goal: const WorkoutGoal(
      type: WorkoutGoalType.time,
      targetDuration: Duration(minutes: 5),
      unit: WorkoutGoalUnit.minutes,
    ),
  ),
  blocks: [
    IntervalBlock(
      type: IntervalBlockType.work,
      iterations: 1,
      steps: [
        IntervalStep(
          alert: HeartRateZoneAlert(zone: 2),
          purpose: IntervalStepPurpose.work,
          step: WorkoutStep(
            alert: HeartRateZoneAlert(zone: 2),
            displayName: "16k Zone 2",
            goal: const WorkoutGoal(
              type: WorkoutGoalType.distance,
              targetValue: 16,
              unit: WorkoutGoalUnit.kilometers,
            ),
          ),
        ),
      ],
    ),
    IntervalBlock(
      type: IntervalBlockType.work,
      iterations: 1,
      steps: [
        IntervalStep(
          purpose: IntervalStepPurpose.work,
          alert: HeartRateZoneAlert(zone: 3),
          step: WorkoutStep(
            displayName: "5k Zone 3",
            goal: const WorkoutGoal(
              type: WorkoutGoalType.distance,
              targetValue: 5,
              unit: WorkoutGoalUnit.kilometers,
            ),
          ),
        ),
      ],
    ),
  ],
  cooldown: WorkoutStep(
    alert: HeartRateZoneAlert(zone: 1),
    displayName: "5 min cooldown",
    goal: const WorkoutGoal(
      type: WorkoutGoalType.time,
      targetDuration: Duration(minutes: 5),
      unit: WorkoutGoalUnit.minutes,
    ),
  ),
);
