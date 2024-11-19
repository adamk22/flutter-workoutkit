import 'package:flutter_workoutkit/workoutkit.dart';

final SingleGoalWorkout sampleSingleGoalTimedWorkout = SingleGoalWorkout(
  activityType: WorkoutActivityType.running,
  location: WorkoutLocationType.indoor,
  goal: const WorkoutGoal(
    type: WorkoutGoalType.time,
    targetDuration: Duration(minutes: 30),
    unit: WorkoutGoalUnit.minutes,
  ),
);

final SingleGoalWorkout sampleSingleGoalEnergyWorkout = SingleGoalWorkout(
  activityType: WorkoutActivityType.cycling,
  location: WorkoutLocationType.outdoor,
  goal: const WorkoutGoal(
    type: WorkoutGoalType.energy,
    targetValue: 1000,
    unit: WorkoutGoalUnit.calories,
  ),
);

final SingleGoalWorkout sampleSingleOpenWorkout = SingleGoalWorkout(
  activityType: WorkoutActivityType.basketball,
  location: WorkoutLocationType.outdoor,
  goal: const WorkoutGoal(
    type: WorkoutGoalType.open,
  ),
);

final SingleGoalWorkout sampleSingleGoalSwimmingWorkout = SingleGoalWorkout(
  activityType: WorkoutActivityType.swimming,
  swimmingLocation: WorkoutSwimmingLocationType.pool,
  goal: const WorkoutGoal(
    type: WorkoutGoalType.distance,
    targetValue: 1000,
    unit: WorkoutGoalUnit.meters,
  ),
);
