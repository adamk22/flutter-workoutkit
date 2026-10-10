import 'classes/index.dart';
import 'workoutkit_platform_interface.dart';

/// Schedules workouts in the Workout app on the user's paired Apple Watch.
///
/// Call [requestAuthorization] first. Scheduling needs a paired Apple Watch
/// running watchOS 10+; check [isSupported]. Errors are thrown as
/// `WorkoutkitException`.
abstract final class WorkoutScheduler {
  static WorkoutkitPlatform get _platform => WorkoutkitPlatform.instance;

  /// Whether the device supports scheduling workouts.
  static Future<bool> isSupported() => _platform.schedulerIsSupported();

  /// The current authorization state, without prompting the user.
  static Future<SchedulerAuthorizationState> authorizationState() =>
      _platform.schedulerAuthorizationState();

  /// Prompts the user (once) for permission to schedule workouts.
  static Future<SchedulerAuthorizationState> requestAuthorization() =>
      _platform.schedulerRequestAuthorization();

  /// The maximum number of workouts an app may have scheduled at once.
  static Future<int> maxAllowedScheduledWorkoutCount() =>
      _platform.schedulerMaxAllowedScheduledWorkoutCount();

  /// Schedules [workout] at [date] (local time, minute precision).
  ///
  /// Returns the scheduled workout including its plan id, which is needed to
  /// [remove] or [markComplete] it later.
  static Future<ScheduledWorkout> schedule(Workout workout, DateTime date) =>
      _platform.schedulerSchedule(workout, date);

  /// The workouts this app has scheduled.
  static Future<List<ScheduledWorkout>> scheduledWorkouts() =>
      _platform.schedulerScheduledWorkouts();

  /// Removes [scheduled] from the Watch.
  static Future<void> remove(ScheduledWorkout scheduled) =>
      _platform.schedulerRemove(scheduled.id, scheduled.date);

  /// Marks [scheduled] as complete.
  static Future<void> markComplete(ScheduledWorkout scheduled) =>
      _platform.schedulerMarkComplete(scheduled.id, scheduled.date);

  /// Removes all workouts this app has scheduled.
  static Future<void> removeAll() => _platform.schedulerRemoveAll();
}
