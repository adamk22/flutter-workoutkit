import 'package:workoutkit/workoutkit.dart';

CustomWorkout test_workout = CustomWorkout(
  activityType: WorkoutActivityType.running,
  location: WorkoutLocationType.outdoor,
  displayName: "5K Training Run",
  warmup: WorkoutStep(
    goal: const WorkoutGoal(
      type: WorkoutGoalType.time,
      targetDuration: Duration(minutes: 5),
    ),
  ),
  blocks: [
    IntervalBlock(
      iterations: 4,
      steps: [
        IntervalStep(
          purpose: IntervalStepPurpose.work,
          goal: const WorkoutGoal(
            type: WorkoutGoalType.time,
            targetDuration: Duration(minutes: 1),
          ),
          repeat: 2,
        ),
      ],
    ),
  ],
  cooldown: WorkoutStep(
    goal: const WorkoutGoal(
      type: WorkoutGoalType.time,
      targetDuration: Duration(minutes: 5),
    ),
  ),
);
