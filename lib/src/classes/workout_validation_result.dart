/// The result of `Workoutkit.validate`.
class WorkoutValidationResult {
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

  @override
  String toString() => isValid
      ? 'WorkoutValidationResult(valid)'
      : 'WorkoutValidationResult(invalid: ${issues.join('; ')})';
}
