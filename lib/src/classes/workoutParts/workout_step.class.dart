import 'package:flutter_workoutkit/flutter_workoutkit.dart';

/// Represents a workout step
class WorkoutStep {
  /// The goal of the step
  final WorkoutGoal goal;

  /// The alert of the step
  final WorkoutAlert? alert;

  /// The display name of the step
  final String? displayName;

  /// Creates a new workout step
  WorkoutStep({
    required this.goal,
    this.alert,
    this.displayName,
  });

  /// Converts the workout step to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'goal': goal.toJson(),
      'alert': alert?.toJson(),
      'displayName': displayName,
    };
  }

  /// Creates a new workout step from a JSON object
  static WorkoutStep fromJson(Map<String, dynamic> json) {
    return WorkoutStep(
      goal: WorkoutGoal.fromJson(json['goal'] as Map<String, dynamic>),
      alert: json['alert'] != null
          ? WorkoutAlert.fromJson(json['alert'] as Map<String, dynamic>)
          : null,
      displayName: json['displayName'],
    );
  }
}
