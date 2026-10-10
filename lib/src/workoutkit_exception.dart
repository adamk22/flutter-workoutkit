import 'package:flutter/services.dart';

import 'classes/workout_validation_result.dart';
import 'utils/json.dart';

/// An error reported by the native WorkoutKit side.
///
/// See [WorkoutkitErrorCode] for the possible [code] values.
class WorkoutkitException implements Exception {
  /// A machine readable error code, one of the [WorkoutkitErrorCode] values.
  final String code;

  /// A human readable description.
  final String? message;

  /// Extra details, if any.
  final Object? details;

  /// Creates a new exception.
  const WorkoutkitException(this.code, [this.message, this.details]);

  /// Wraps a [PlatformException] from the method channel.
  factory WorkoutkitException.fromPlatformException(PlatformException e) =>
      WorkoutkitException(e.code, e.message, e.details);

  /// The structured problems behind an [WorkoutkitErrorCode.unsupportedWorkout]
  /// or [WorkoutkitErrorCode.unsupportedOS] error; empty for other errors.
  List<WorkoutValidationIssue> get validationIssues {
    final details = this.details;
    if (details is! List) return const [];
    return [
      for (final item in details)
        if (item is Map) WorkoutValidationIssue.fromJson(asJsonMap(item)),
    ];
  }

  @override
  String toString() => 'WorkoutkitException($code, $message)';
}

/// Error codes used by [WorkoutkitException.code].
abstract final class WorkoutkitErrorCode {
  /// The workout JSON could not be turned into a WorkoutKit plan.
  static const invalidArgument = 'INVALID_ARGUMENT';

  /// The feature needs a newer iOS version (e.g. pool swim goals need 18.0).
  static const unsupportedOS = 'UNSUPPORTED_OS';

  /// WorkoutKit doesn't support this combination of activity, location,
  /// goals or alerts. See [WorkoutkitException.validationIssues]. Use
  /// `WorkoutKit.validate` to check up front.
  static const unsupportedWorkout = 'UNSUPPORTED_WORKOUT';

  /// `presentPreview` found no visible view controller to present from.
  static const noPresenter = 'NO_PRESENTER';

  /// `presentPreview` was called while a preview is already on screen.
  static const alreadyPresenting = 'ALREADY_PRESENTING';

  /// No Apple Watch is paired with this iPhone (WorkoutKit `StateError`).
  static const watchNotPaired = 'WATCH_NOT_PAIRED';

  /// The Workout app isn't installed on the paired Apple Watch (WorkoutKit
  /// `StateError`).
  static const workoutAppNotInstalled = 'WORKOUT_APP_NOT_INSTALLED';

  /// An unexpected native error; see the message.
  static const unknown = 'UNKNOWN';

  /// The call isn't available on this platform (WorkoutKit is iOS only).
  static const unsupportedPlatform = 'UNSUPPORTED_PLATFORM';

  /// A scheduled workout with the given id and date was not found.
  static const notFound = 'NOT_FOUND';

  /// Exporting or importing a workout plan failed.
  static const serialization = 'SERIALIZATION_ERROR';

  /// Requesting HealthKit permissions failed.
  static const healthPermission = 'HEALTH_PERMISSION_ERROR';
}
