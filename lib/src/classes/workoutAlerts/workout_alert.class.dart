import 'package:flutter_workoutkit/workoutkit.dart';

/// Represents a workout alert
class WorkoutAlert {
  /// The type of the workout alert
  final WorkoutAlertType type;

  /// Creates a new workout alert
  WorkoutAlert({required this.type});

  /// Converts the workout alert to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'type': type.toString().split('.').last,
    };
  }
}
