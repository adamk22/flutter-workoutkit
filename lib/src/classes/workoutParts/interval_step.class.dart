import 'package:flutter_workoutkit/workoutkit.dart';

/// Represents an interval step
class IntervalStep {
  /// The purpose of the step
  final IntervalStepPurpose purpose;

  /// The goal of the step (optional)
  final WorkoutGoal? goal;

  /// The alert of the step (optional)
  /// Either goal or alert must be provided, but not both
  final WorkoutAlert? alert;

  /// The step of the workout (optional)
  /// Either goal or step must be provided, but not both
  /// step is useful for adding a custom display name to the step
  final WorkoutStep? step;

  /// Creates a new interval step
  IntervalStep({
    required this.purpose,
    this.goal,
    this.step,
    this.alert,
  }) : assert(
          (goal != null) != (step != null),
          'Either goal or step must be provided, but not both',
        );

  /// Converts the interval step to a JSON object
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
