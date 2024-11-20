import '../../enums/index.dart';

/// Base class for all workout types
abstract class Workout {
  /// The type of workout this represents
  final WorkoutType workoutType;

  /// Creates a new workout
  Workout({
    required this.workoutType,
  });

  /// Converts the workout to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'workoutType': workoutType.name,
    };
  }
}
