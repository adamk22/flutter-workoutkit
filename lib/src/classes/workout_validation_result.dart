import 'package:flutter_workoutkit/src/utils/json.dart';
import 'package:flutter_workoutkit/src/utils/json_equality.dart';

/// The kind of problem a [WorkoutValidationIssue] describes.
enum WorkoutValidationIssueCode {
  /// The activity isn't supported for this workout type.
  unsupportedActivity,

  /// A goal isn't supported for the activity and location.
  unsupportedGoal,

  /// An alert isn't supported for the activity and location.
  unsupportedAlert,

  /// The order of swim/bike/run legs isn't supported.
  unsupportedActivityOrdering,

  /// A custom workout has no interval blocks.
  missingBlocks,

  /// A swim bike run workout has no activities.
  missingActivities,

  /// The workout uses a feature that needs a newer iOS version.
  unsupportedOS,

  /// The workout data is malformed, or the problem is otherwise unknown.
  invalidWorkout;

  /// Parses a native code, falling back to [invalidWorkout] for codes added
  /// by newer native versions.
  static WorkoutValidationIssueCode fromString(String? value) =>
      WorkoutValidationIssueCode.values
          .firstWhere((c) => c.name == value, orElse: () => invalidWorkout);
}

/// A single problem found by `WorkoutKit.validate` or reported in a
/// `WorkoutkitException`.
class WorkoutValidationIssue with JsonValueEquality {
  /// What kind of problem this is.
  final WorkoutValidationIssueCode code;

  /// Where in the workout the problem is, relative to the workout's JSON,
  /// e.g. `blocks[0].steps[1]`, `activityType` or `goal`. Null when the
  /// problem concerns the whole workout.
  final String? path;

  /// A human readable (English) description.
  final String message;

  /// Creates a new validation issue.
  const WorkoutValidationIssue({
    required this.code,
    required this.message,
    this.path,
  });

  /// Creates an issue from the native payload.
  factory WorkoutValidationIssue.fromJson(Map<String, dynamic> json) =>
      WorkoutValidationIssue(
        code: WorkoutValidationIssueCode.fromString(json['code'] as String?),
        path: json['path'] as String?,
        message: json['message'] as String? ?? '',
      );

  @override
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{'code': code.name, 'message': message};
    putIfNotNull(json, 'path', path);
    return json;
  }

  @override
  String toString() => 'WorkoutValidationIssue(${code.name}'
      '${path == null ? '' : ' at $path'}: $message)';
}

/// The result of `WorkoutKit.validate`.
class WorkoutValidationResult with JsonValueEquality {
  /// Whether WorkoutKit supports the workout on this device.
  final bool isValid;

  /// Human readable problems, empty when [isValid] is true. Same order as
  /// [details].
  final List<String> issues;

  /// Structured problems with a code and a path, for localized messages or
  /// highlighting the offending step.
  final List<WorkoutValidationIssue> details;

  /// Creates a new validation result.
  const WorkoutValidationResult({
    required this.isValid,
    required this.issues,
    this.details = const [],
  });

  /// Creates a validation result from the native response.
  factory WorkoutValidationResult.fromJson(Map<String, dynamic> json) =>
      WorkoutValidationResult(
        isValid: json['isValid'] as bool,
        issues: (json['issues'] as List).cast<String>(),
        details: json['details'] == null
            ? const []
            : asJsonList(json['details'])
                .map(WorkoutValidationIssue.fromJson)
                .toList(),
      );

  /// Converts the result to a JSON object.
  @override
  Map<String, dynamic> toJson() => {
        'isValid': isValid,
        'issues': issues,
        'details': details.map((d) => d.toJson()).toList(),
      };

  @override
  String toString() => isValid
      ? 'WorkoutValidationResult(valid)'
      : 'WorkoutValidationResult(invalid: ${issues.join('; ')})';
}
