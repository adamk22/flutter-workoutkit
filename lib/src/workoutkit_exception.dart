import 'package:flutter/services.dart';

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
  /// goals or alerts. [WorkoutkitException.details] lists the issues. Use
  /// `Workoutkit.validate` to check up front.
  static const unsupportedWorkout = 'UNSUPPORTED_WORKOUT';

  /// A scheduled workout with the given id and date was not found.
  static const notFound = 'NOT_FOUND';

  /// Exporting or importing a workout plan failed.
  static const serialization = 'SERIALIZATION_ERROR';

  /// Requesting HealthKit permissions failed.
  static const healthPermission = 'HEALTH_PERMISSION_ERROR';
}
