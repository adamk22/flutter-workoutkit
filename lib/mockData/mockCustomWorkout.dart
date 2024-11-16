import 'package:flutter_workoutkit/classes/workouts/CustomWorkout.class.dart';
import 'package:flutter_workoutkit/classes/workoutParts/IntervalBlock.class.dart';
import 'package:flutter_workoutkit/classes/workoutParts/IntervalStep.class.dart';
import 'package:flutter_workoutkit/classes/workoutParts/WorkoutGoal.class.dart';
import 'package:flutter_workoutkit/classes/workoutParts/WorkoutStep.class.dart';
import 'package:flutter_workoutkit/enums/WorkoutActivityType.enum.dart';
import 'package:flutter_workoutkit/enums/WorkoutLocationType.enum.dart';

final CustomWorkout mockCustomWorkout = CustomWorkout(
  activityType: WorkoutActivityType.running,
  location: WorkoutLocationType.outdoor,
  displayName: "5K Training Run",
  warmup: WorkoutStep(
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
          purpose: IntervalStepPurpose.work,
          goal: const WorkoutGoal(
            type: WorkoutGoalType.time,
            targetDuration: Duration(minutes: 2),
            unit: WorkoutGoalUnit.minutes,
          ),
        ),
        IntervalStep(
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
    goal: const WorkoutGoal(
      type: WorkoutGoalType.time,
      targetDuration: Duration(minutes: 5),
      unit: WorkoutGoalUnit.minutes,
    ),
  ),
);
