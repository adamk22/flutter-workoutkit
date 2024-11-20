import '../../enums/index.dart';

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
