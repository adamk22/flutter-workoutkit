import 'package:workoutkit/classes/workoutParts/WorkoutAlert.class.dart';
import 'package:workoutkit/classes/workoutParts/WorkoutGoal.class.dart';

class WorkoutStep {
  final WorkoutGoal goal;
  final WorkoutAlert? alert;

  WorkoutStep({
    required this.goal,
    this.alert,
  });

  Map<String, dynamic> toJson() {
    return {
      'goal': goal.toJson(),
      'alert': alert?.toJson(),
    };
  }
}
