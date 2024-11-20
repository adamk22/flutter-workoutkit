import '../../enums/index.dart';

abstract class Workout {
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
