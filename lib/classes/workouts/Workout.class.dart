import 'package:flutter_workoutkit/enums/workout_type.enum.dart';

class Workout {
  final WorkoutType workoutType;

  Workout({
    required this.workoutType,
  });

  Map<String, dynamic> toJson() {
    return {
      'workoutType': workoutType.name,
    };
  }
}
