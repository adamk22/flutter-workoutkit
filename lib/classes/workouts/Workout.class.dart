import 'package:flutter_workoutkit/enums/WorkoutActivityType.enum.dart';
import 'package:flutter_workoutkit/enums/WorkoutType.enum.dart';

class Workout {
  final WorkoutType workoutType;
  final WorkoutActivityType activityType;

  Workout({
    required this.workoutType,
    required this.activityType,
  });

  Map<String, dynamic> toJson() {
    return {
      'workoutType': workoutType.name,
      'activityType': activityType.name,
    };
  }
}
