import 'package:flutter_workoutkit/workoutkit.dart';

/// A sample pacer workout for running
final PacerWorkout samplePacerMinutesWorkout = PacerWorkout(
  activityType: WorkoutActivityType.running,
  location: WorkoutLocationType.outdoor,
  targetValue: 1000,
  targetValueUnit: GoalDistanceUnits.meters,
  targetDuration: const Duration(minutes: 30),
  targetDurationUnit: GoalTimeUnits.minutes,
);

/// A sample pacer workout for cycling
final PacerWorkout samplePacerHoursWorkout = PacerWorkout(
  activityType: WorkoutActivityType.cycling,
  location: WorkoutLocationType.outdoor,
  targetValue: 50.5,
  targetValueUnit: GoalDistanceUnits.kilometers,
  targetDuration: const Duration(hours: 2),
  targetDurationUnit: GoalTimeUnits.hours,
);
