import 'package:flutter_workoutkit/flutter_workoutkit.dart';

/// A sample speed cycling workout
final CustomWorkout sampleSpeedCyclingWorkout = CustomWorkout(
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

/// A sample timed run workout
final CustomWorkout sampleCustomWorkout = CustomWorkout(
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

/// A sample 10k training run workout
final CustomWorkout sample10kTrainingRun = CustomWorkout(
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

/// A sample 21km stepped run workout
final CustomWorkout sample21kmTrainingRun = CustomWorkout(
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
      iterations: 1,
      steps: [
        IntervalStep(
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
      iterations: 1,
      steps: [
        IntervalStep(
          purpose: IntervalStepPurpose.work,
          step: WorkoutStep(
            alert: HeartRateZoneAlert(zone: 3),
            displayName: "3k Zone 3",
            goal: const WorkoutGoal(
              type: WorkoutGoalType.distance,
              targetValue: 3,
              unit: WorkoutGoalUnit.kilometers,
            ),
          ),
        ),
      ],
    ),
    IntervalBlock(
      iterations: 1,
      steps: [
        IntervalStep(
          purpose: IntervalStepPurpose.work,
          alert: HeartRateZoneAlert(zone: 1),
          goal: const WorkoutGoal(
            type: WorkoutGoalType.distance,
            targetValue: 2,
            unit: WorkoutGoalUnit.kilometers,
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

/// A sample tempo run with pace alerts (5:00–5:30 per km).
final CustomWorkout sampleTempoPaceRun = CustomWorkout(
  activityType: WorkoutActivityType.running,
  location: WorkoutLocationType.outdoor,
  displayName: "Tempo Run",
  warmup: WorkoutStep(
    goal: const WorkoutGoal.time(Duration(minutes: 10)),
    alert: HeartRateZoneAlert(zone: 2),
  ),
  blocks: [
    IntervalBlock(
      iterations: 3,
      steps: [
        IntervalStep(
          purpose: IntervalStepPurpose.work,
          goal: const WorkoutGoal.distance(2, WorkoutGoalUnit.kilometers),
          alert: PaceRangeAlert(
            fastestPace: const Duration(minutes: 5),
            slowestPace: const Duration(minutes: 5, seconds: 30),
          ),
        ),
        IntervalStep(
          purpose: IntervalStepPurpose.recovery,
          goal: const WorkoutGoal.time(Duration(seconds: 90),
              unit: WorkoutGoalUnit.seconds),
        ),
      ],
    ),
  ],
  cooldown: WorkoutStep(goal: const WorkoutGoal.time(Duration(minutes: 5))),
);

/// A sample pool swim interval workout: 8 × 100 m, each within 2 minutes.
/// Pool swim goals require iOS 18.0+.
final CustomWorkout samplePoolSwimIntervals = CustomWorkout(
  activityType: WorkoutActivityType.swimming,
  location: WorkoutLocationType.indoor,
  displayName: "Pool Intervals",
  warmup: WorkoutStep(
    goal: const WorkoutGoal.distance(200, WorkoutGoalUnit.meters),
  ),
  blocks: [
    IntervalBlock(
      iterations: 8,
      steps: [
        IntervalStep(
          purpose: IntervalStepPurpose.work,
          goal: const WorkoutGoal.poolSwimDistanceWithTime(
            distance: 100,
            distanceUnit: WorkoutGoalUnit.meters,
            duration: Duration(minutes: 2),
          ),
        ),
        IntervalStep(
          purpose: IntervalStepPurpose.recovery,
          goal: const WorkoutGoal.time(Duration(seconds: 30),
              unit: WorkoutGoalUnit.seconds),
        ),
      ],
    ),
  ],
  cooldown: WorkoutStep(
    goal: const WorkoutGoal.distance(200, WorkoutGoalUnit.meters),
  ),
);
