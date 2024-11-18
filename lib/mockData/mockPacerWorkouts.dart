import 'package:flutter_workoutkit/workoutkit.dart';

final PacerWorkout mockPacerMinutesWorkout = PacerWorkout(
  activityType: WorkoutActivityType.running,
  location: WorkoutLocationType.outdoor,
  targetValue: 1000,
  targetValueUnit: GoalDistanceUnits.meters,
  targetDuration: const Duration(minutes: 30),
  targetDurationUnit: GoalTimeUnits.minutes,
);

final PacerWorkout mockPacerHoursWorkout = PacerWorkout(
  activityType: WorkoutActivityType.cycling,
  location: WorkoutLocationType.outdoor,
  targetValue: 50.5,
  targetValueUnit: GoalDistanceUnits.kilometers,
  targetDuration: const Duration(hours: 2),
  targetDurationUnit: GoalTimeUnits.hours,
);
