import 'package:flutter/services.dart';
import 'package:workoutkit/classes/IntervalBlock.class.dart';
import 'package:workoutkit/classes/IntervalStep.class.dart';
import 'package:workoutkit/classes/WorkoutGoal.class.dart';
import 'package:workoutkit/classes/WorkoutStep.class.dart';
import 'package:workoutkit/classes/CustomWorkout.class.dart';
import 'package:workoutkit/enums/WorkoutActivityType.enum.dart';
import 'package:workoutkit/enums/WorkoutLocationType.enum.dart';

CustomWorkout exampleCustomWorkout = CustomWorkout(
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

class WorkoutService {
  static Future<void> startWorkout() async {
    // Example workout creation
    final customWorkout = exampleCustomWorkout;

    try {
      await const MethodChannel('workoutkit').invokeMethod(
        'createCustomWorkout',
        customWorkout.toJson(),
      );
    } catch (e) {
      print('Error creating workout: $e');
    }
  }
}
