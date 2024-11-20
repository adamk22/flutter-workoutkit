import 'package:flutter_workoutkit/workoutkit.dart';

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
}
