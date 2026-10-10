// Verbatim copy of the 0.0.11 sample workouts (identifiers prefixed with
// `legacy`). If this stops compiling, the 0.1.x API broke 0.0.11 code.
// ignore_for_file: deprecated_member_use, prefer_single_quotes

import 'package:flutter_workoutkit/flutter_workoutkit.dart';

/// A sample single goal timed workout
final SingleGoalWorkout legacySampleSingleGoalTimedWorkout = SingleGoalWorkout(
  activityType: WorkoutActivityType.running,
  location: WorkoutLocationType.indoor,
  goal: const WorkoutGoal(
    type: WorkoutGoalType.time,
    targetDuration: Duration(minutes: 30),
    unit: WorkoutGoalUnit.minutes,
  ),
);

/// A sample single goal energy workout
final SingleGoalWorkout legacySampleSingleGoalEnergyWorkout = SingleGoalWorkout(
  activityType: WorkoutActivityType.cycling,
  location: WorkoutLocationType.outdoor,
  goal: const WorkoutGoal(
    type: WorkoutGoalType.energy,
    targetValue: 1000,
    unit: WorkoutGoalUnit.calories,
  ),
);

/// A sample single goal open workout
final SingleGoalWorkout legacySampleSingleOpenWorkout = SingleGoalWorkout(
  activityType: WorkoutActivityType.basketball,
  location: WorkoutLocationType.outdoor,
  goal: const WorkoutGoal(
    type: WorkoutGoalType.open,
  ),
);

/// A sample single goal swimming workout
final SingleGoalWorkout legacySampleSingleGoalSwimmingWorkout =
    SingleGoalWorkout(
  activityType: WorkoutActivityType.swimming,
  swimmingLocation: WorkoutSwimmingLocationType.pool,
  goal: const WorkoutGoal(
    type: WorkoutGoalType.distance,
    targetValue: 1000,
    unit: WorkoutGoalUnit.meters,
  ),
);

/// A sample pacer workout for running
final PacerWorkout legacySamplePacerMinutesWorkout = PacerWorkout(
  activityType: WorkoutActivityType.running,
  location: WorkoutLocationType.outdoor,
  targetValue: 1000,
  targetValueUnit: GoalDistanceUnits.meters,
  targetDuration: const Duration(minutes: 30),
  targetDurationUnit: GoalTimeUnits.minutes,
);

/// A sample pacer workout for cycling
final PacerWorkout legacySamplePacerHoursWorkout = PacerWorkout(
  activityType: WorkoutActivityType.cycling,
  location: WorkoutLocationType.outdoor,
  targetValue: 50.5,
  targetValueUnit: GoalDistanceUnits.kilometers,
  targetDuration: const Duration(hours: 2),
  targetDurationUnit: GoalTimeUnits.hours,
);

/// A sample speed cycling workout
final CustomWorkout legacySampleSpeedCyclingWorkout = CustomWorkout(
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

/// A sample timed run workout
final CustomWorkout legacySampleCustomWorkout = CustomWorkout(
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

/// A sample 10k training run workout
final CustomWorkout legacySample10kTrainingRun = CustomWorkout(
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

/// A sample 21km stepped run workout
final CustomWorkout legacySample21kmTrainingRun = CustomWorkout(
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
      type: IntervalBlockType.work,
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

/// A sample swim bike run workout
final SwimBikeRunWorkout legacySampleSwimBikeRunWorkout = SwimBikeRunWorkout(
  displayName: 'Triathlon Training',
  activities: [
    MultisportActivity(
      type: MultisportActivityType.swimming,
      swimmingLocation: WorkoutSwimmingLocationType.pool,
    ),
    MultisportActivity(
      type: MultisportActivityType.cycling,
      location: WorkoutLocationType.outdoor,
    ),
    MultisportActivity(
      type: MultisportActivityType.running,
      location: WorkoutLocationType.outdoor,
    ),
  ],
);
