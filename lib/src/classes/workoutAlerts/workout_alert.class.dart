import 'package:flutter_workoutkit/flutter_workoutkit.dart';

/// Represents a workout alert
class WorkoutAlert {
  /// The type of the workout alert
  final WorkoutAlertType type;

  /// Creates a new workout alert
  WorkoutAlert({required this.type});

  /// Returns a string representation of the workout alert
  String toDisplayString() {
    return type.label;
  }

  /// Converts the workout alert to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'type': type.toString().split('.').last,
    };
  }

  /// Creates a new workout alert from a JSON object
  static WorkoutAlert fromJson(Map<String, dynamic> json) {
    return WorkoutAlert(
      type: WorkoutAlertType.fromString(json['type'] as String),
    );
  }
}
