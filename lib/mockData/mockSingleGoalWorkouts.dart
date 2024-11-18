import 'package:flutter_workoutkit/workoutkit.dart';

final SingleGoalWorkout mockSingleGoalTimedWorkout = SingleGoalWorkout(
  activityType: WorkoutActivityType.running,
  location: WorkoutLocationType.indoor,
  goal: const WorkoutGoal(
    type: WorkoutGoalType.time,
    targetDuration: Duration(minutes: 30),
    unit: WorkoutGoalUnit.minutes,
  ),
);

final SingleGoalWorkout mockSingleGoalEnergyWorkout = SingleGoalWorkout(
  activityType: WorkoutActivityType.cycling,
  location: WorkoutLocationType.outdoor,
  goal: const WorkoutGoal(
    type: WorkoutGoalType.energy,
    targetValue: 1000,
    unit: WorkoutGoalUnit.calories,
  ),
);

final SingleGoalWorkout mockSingleOpenWorkout = SingleGoalWorkout(
  activityType: WorkoutActivityType.basketball,
  location: WorkoutLocationType.outdoor,
  goal: const WorkoutGoal(
    type: WorkoutGoalType.open,
  ),
);

final SingleGoalWorkout mockSingleGoalSwimmingWorkout = SingleGoalWorkout(
  activityType: WorkoutActivityType.swimming,
  swimmingLocation: WorkoutSwimmingLocationType.pool,
  goal: const WorkoutGoal(
    type: WorkoutGoalType.distance,
    targetValue: 1000,
    unit: WorkoutGoalUnit.meters,
  ),
);
