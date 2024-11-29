import 'package:flutter_workoutkit/flutter_workoutkit.dart';

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

  /// Creates a new interval step from a JSON object
  static IntervalStep fromJson(Map<String, dynamic> json) {
    return IntervalStep(
      purpose: IntervalStepPurpose.values
          .firstWhere((e) => e.toString().split('.').last == json['purpose']),
      goal: json['goal'] != null
          ? WorkoutGoal.fromJson(json['goal'] as Map<String, dynamic>)
          : null,
      step: json['step'] != null
          ? WorkoutStep.fromJson(json['step'] as Map<String, dynamic>)
          : null,
      alert: json['alert'] != null
          ? WorkoutAlert.fromJson(json['alert'] as Map<String, dynamic>)
          : null,
    );
  }
}

/// The purpose of the interval step
enum IntervalStepPurpose {
  /// The step is a workout step
  work,

  /// The step is a recovery step
  recovery,
}
