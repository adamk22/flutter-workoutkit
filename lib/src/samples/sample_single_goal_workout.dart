import 'package:flutter_workoutkit/flutter_workoutkit.dart';

/// A sample single goal timed workout
final SingleGoalWorkout sampleSingleGoalTimedWorkout = SingleGoalWorkout(
  activityType: WorkoutActivityType.running,
  location: WorkoutLocationType.indoor,
  goal: const WorkoutGoal(
    type: WorkoutGoalType.time,
    targetDuration: Duration(minutes: 30),
    unit: WorkoutGoalUnit.minutes,
  ),
);

/// A sample single goal energy workout
final SingleGoalWorkout sampleSingleGoalEnergyWorkout = SingleGoalWorkout(
  activityType: WorkoutActivityType.cycling,
  location: WorkoutLocationType.outdoor,
  goal: const WorkoutGoal(
    type: WorkoutGoalType.energy,
    targetValue: 1000,
    unit: WorkoutGoalUnit.calories,
  ),
);

/// A sample single goal open workout
final SingleGoalWorkout sampleSingleOpenWorkout = SingleGoalWorkout(
  activityType: WorkoutActivityType.basketball,
  location: WorkoutLocationType.outdoor,
  goal: const WorkoutGoal(
    type: WorkoutGoalType.open,
  ),
);

/// A sample single goal swimming workout
final SingleGoalWorkout sampleSingleGoalSwimmingWorkout = SingleGoalWorkout(
  activityType: WorkoutActivityType.swimming,
  swimmingLocation: WorkoutSwimmingLocationType.pool,
  goal: const WorkoutGoal(
    type: WorkoutGoalType.distance,
    targetValue: 1000,
    unit: WorkoutGoalUnit.meters,
  ),
);
