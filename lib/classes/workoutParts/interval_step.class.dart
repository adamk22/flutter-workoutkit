import 'package:flutter_workoutkit/workoutkit.dart';

class IntervalStep {
  final IntervalStepPurpose purpose;
  final WorkoutGoal? goal;
  final WorkoutAlert? alert;
  final WorkoutStep? step;

  IntervalStep({
    required this.purpose,
    this.goal,
    this.step,
    this.alert,
  }) : assert(
          (goal != null) != (step != null),
          'Either goal or step must be provided, but not both',
        );

  Map<String, dynamic> toJson() {
    return {
      'purpose': purpose.toString().split('.').last,
      'goal': goal?.toJson(),
      'step': step?.toJson(),
      'alert': alert?.toJson(),
    };
  }
}

enum IntervalStepPurpose {
  work,
  recovery,
}
