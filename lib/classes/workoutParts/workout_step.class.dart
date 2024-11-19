import 'package:flutter_workoutkit/workoutkit.dart';

class WorkoutStep {
  final WorkoutGoal goal;
  final WorkoutAlert? alert;
  final String? displayName;

  WorkoutStep({
    required this.goal,
    this.alert,
    this.displayName,
  });

  Map<String, dynamic> toJson() {
    return {
      'goal': goal.toJson(),
      'alert': alert?.toJson(),
      'displayName': displayName,
    };
  }
}
