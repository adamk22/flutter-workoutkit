import 'package:flutter_workoutkit/flutter_workoutkit.dart';
import 'package:flutter_workoutkit/src/utils/json.dart';

/// A work or recovery step inside an [IntervalBlock].
class IntervalStep {
  /// The purpose of the step.
  final IntervalStepPurpose purpose;

  /// The goal of the step. Either [goal] or [step] must be provided, but not
  /// both.
  final WorkoutGoal? goal;

  /// The alert of the step (optional). When used together with [step] it
  /// replaces the step's alert.
  final WorkoutAlert? alert;

  /// The full step. Useful for adding a display name to the step.
  final WorkoutStep? step;

  /// Creates a new interval step.
  IntervalStep({
    required this.purpose,
    this.goal,
    this.step,
    this.alert,
  }) : assert(
          (goal != null) != (step != null),
          'Either goal or step must be provided, but not both',
        );

  /// Converts the interval step to a JSON object.
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{'purpose': purpose.name};
    putIfNotNull(json, 'goal', goal?.toJson());
    putIfNotNull(json, 'step', step?.toJson());
    putIfNotNull(json, 'alert', alert?.toJson());
    return json;
  }

  /// Creates a new interval step from a JSON object.
  static IntervalStep fromJson(Map<String, dynamic> json) {
    return IntervalStep(
      purpose: IntervalStepPurpose.values.byName(json['purpose'] as String),
      goal: json['goal'] != null
          ? WorkoutGoal.fromJson(asJsonMap(json['goal']))
          : null,
      step: json['step'] != null
          ? WorkoutStep.fromJson(asJsonMap(json['step']))
          : null,
      alert: json['alert'] != null
          ? WorkoutAlert.fromJson(asJsonMap(json['alert']))
          : null,
    );
  }
}

/// The purpose of an [IntervalStep].
enum IntervalStepPurpose {
  /// A work step.
  work,

  /// A recovery step.
  recovery,
}
