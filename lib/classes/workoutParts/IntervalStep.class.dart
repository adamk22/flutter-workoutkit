import 'package:flutter_workoutkit/classes/workoutParts/WorkoutAlert.class.dart';
import 'package:flutter_workoutkit/classes/workoutParts/WorkoutGoal.class.dart';

class IntervalStep {
  final IntervalStepPurpose purpose;
  final WorkoutGoal goal;
  final WorkoutAlert? alert;
  // final int repeat;

  IntervalStep({
    required this.purpose,
    required this.goal,
    // required this.repeat,
    this.alert,
  });

  Map<String, dynamic> toJson() {
    return {
      'purpose': purpose.toString().split('.').last,
      'goal': goal.toJson(),
      'alert': alert?.toJson(),
      // 'repeat': repeat,
    };
  }
}

enum IntervalStepPurpose {
  work,
  recovery,
}
