import 'package:flutter_workoutkit/src/utils/json_equality.dart';

/// The result of `Workoutkit.validate`.
class WorkoutValidationResult with JsonValueEquality {
  /// Whether WorkoutKit supports the workout on this device.
  final bool isValid;

  /// Human readable problems, empty when [isValid] is true.
  final List<String> issues;

  /// Creates a new validation result.
  const WorkoutValidationResult({required this.isValid, required this.issues});

  /// Creates a validation result from the native response.
  factory WorkoutValidationResult.fromJson(Map<String, dynamic> json) =>
      WorkoutValidationResult(
        isValid: json['isValid'] as bool,
        issues: (json['issues'] as List).cast<String>(),
      );

  /// Converts the result to a JSON object.
  @override
  Map<String, dynamic> toJson() => {'isValid': isValid, 'issues': issues};

  @override
  String toString() => isValid
      ? 'WorkoutValidationResult(valid)'
      : 'WorkoutValidationResult(invalid: ${issues.join('; ')})';
}
