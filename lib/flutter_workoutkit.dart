export 'src/classes/index.dart';
export 'src/enums/index.dart';
export 'src/samples/index.dart';
export 'src/workout_preview_button.dart';
export 'src/workout_scheduler.dart';
export 'src/workoutkit_exception.dart';

import 'package:flutter/foundation.dart';

import 'src/classes/index.dart';
import 'src/workoutkit_exception.dart';
import 'src/workoutkit_platform_interface.dart';

/// The original name of [WorkoutKit]. Kept so existing code keeps working;
/// both names refer to the same class.
typedef Workoutkit = WorkoutKit;

/// Entry point for workout validation, import/export and (deprecated)
/// HealthKit permissions. See also `WorkoutScheduler` and
/// `WorkoutPreviewButton`.
abstract final class WorkoutKit {
  /// Gets the platform version.
  static Future<String?> getPlatformVersion() {
    return WorkoutkitPlatform.instance.getPlatformVersion();
  }

  /// Requests HealthKit workout permissions.
  @Deprecated('Not required by WorkoutKit. Use '
      'WorkoutScheduler.requestAuthorization to schedule workouts.')
  static Future<void> requestHealthPermissions() {
    return WorkoutkitPlatform.instance.requestHealthPermissions();
  }

  /// Gets the HealthKit workout sharing permission status.
  @Deprecated('Not required by WorkoutKit. Use '
      'WorkoutScheduler.authorizationState to check scheduling access.')
  static Future<bool> hasHealthPermissions() {
    return WorkoutkitPlatform.instance.hasHealthPermissions();
  }

  /// Checks [workout] against WorkoutKit's rules for this device: supported
  /// activity, goals, alerts and activity ordering, plus OS requirements
  /// such as iOS 18 for pool swim goals.
  static Future<WorkoutValidationResult> validate(Workout workout) {
    return WorkoutkitPlatform.instance.validateWorkout(workout);
  }

  /// Opens Apple's workout preview sheet for [workout] from your own UI, e.g.
  /// a Flutter button. The user can add the workout to their Apple Watch
  /// from the sheet. Completes when the sheet is dismissed.
  ///
  /// Throws a [WorkoutkitException] with code
  /// [WorkoutkitErrorCode.unsupportedWorkout], [WorkoutkitErrorCode.unsupportedOS],
  /// [WorkoutkitErrorCode.alreadyPresenting], [WorkoutkitErrorCode.noPresenter]
  /// or, on other platforms, [WorkoutkitErrorCode.unsupportedPlatform].
  ///
  /// `WorkoutPreviewButton` remains available as a ready-made native button.
  static Future<void> presentPreview(Workout workout) {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.iOS) {
      return Future.error(const WorkoutkitException(
        WorkoutkitErrorCode.unsupportedPlatform,
        'presentPreview is only available on iOS',
      ));
    }
    return WorkoutkitPlatform.instance.presentPreview(workout);
  }

  /// Serializes [workout] using WorkoutKit's own binary format, e.g. to share
  /// it or store it.
  static Future<Uint8List> exportWorkout(Workout workout) {
    return WorkoutkitPlatform.instance.exportWorkout(workout);
  }

  /// Reads a workout previously produced by [exportWorkout].
  static Future<Workout> importWorkout(Uint8List data) {
    return WorkoutkitPlatform.instance.importWorkout(data);
  }
}
