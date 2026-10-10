import 'dart:typed_data';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'classes/index.dart';
import 'workoutkit_method_channel.dart';

/// The platform interface for the workoutkit plugin.
///
/// Implementations throw `WorkoutkitException` on native errors.
abstract class WorkoutkitPlatform extends PlatformInterface {
  /// Constructs a WorkoutkitPlatform.
  WorkoutkitPlatform() : super(token: _token);

  static final Object _token = Object();

  static WorkoutkitPlatform _instance = MethodChannelWorkoutkit();

  /// The default instance of [WorkoutkitPlatform] to use.
  ///
  /// Defaults to [MethodChannelWorkoutkit].
  static WorkoutkitPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [WorkoutkitPlatform] when
  /// they register themselves.
  static set instance(WorkoutkitPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Gets the platform version.
  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  /// Requests HealthKit workout permissions.
  Future<void> requestHealthPermissions() {
    throw UnimplementedError(
        'requestHealthPermissions() has not been implemented.');
  }

  /// Gets the HealthKit workout sharing permission status.
  Future<bool> hasHealthPermissions() {
    throw UnimplementedError(
        'hasHealthPermissions() has not been implemented.');
  }

  /// Checks [workout] against WorkoutKit's supported activities, goals and
  /// alerts.
  Future<WorkoutValidationResult> validateWorkout(Workout workout) {
    throw UnimplementedError('validateWorkout() has not been implemented.');
  }

  /// Serializes [workout] with WorkoutKit's `dataRepresentation`.
  Future<Uint8List> exportWorkout(Workout workout) {
    throw UnimplementedError('exportWorkout() has not been implemented.');
  }

  /// Reads a workout from WorkoutKit's `dataRepresentation`.
  Future<Workout> importWorkout(Uint8List data) {
    throw UnimplementedError('importWorkout() has not been implemented.');
  }

  /// Whether the device supports scheduling workouts.
  Future<bool> schedulerIsSupported() {
    throw UnimplementedError(
        'schedulerIsSupported() has not been implemented.');
  }

  /// The current scheduler authorization state.
  Future<SchedulerAuthorizationState> schedulerAuthorizationState() {
    throw UnimplementedError(
        'schedulerAuthorizationState() has not been implemented.');
  }

  /// Requests scheduler authorization.
  Future<SchedulerAuthorizationState> schedulerRequestAuthorization() {
    throw UnimplementedError(
        'schedulerRequestAuthorization() has not been implemented.');
  }

  /// The maximum number of workouts an app may schedule.
  Future<int> schedulerMaxAllowedScheduledWorkoutCount() {
    throw UnimplementedError(
        'schedulerMaxAllowedScheduledWorkoutCount() has not been implemented.');
  }

  /// Schedules [workout] at [date].
  Future<ScheduledWorkout> schedulerSchedule(Workout workout, DateTime date) {
    throw UnimplementedError('schedulerSchedule() has not been implemented.');
  }

  /// Lists the app's scheduled workouts.
  Future<List<ScheduledWorkout>> schedulerScheduledWorkouts() {
    throw UnimplementedError(
        'schedulerScheduledWorkouts() has not been implemented.');
  }

  /// Removes the scheduled workout with plan [id] at [date].
  Future<void> schedulerRemove(String id, DateTime date) {
    throw UnimplementedError('schedulerRemove() has not been implemented.');
  }

  /// Marks the scheduled workout with plan [id] at [date] complete.
  Future<void> schedulerMarkComplete(String id, DateTime date) {
    throw UnimplementedError(
        'schedulerMarkComplete() has not been implemented.');
  }

  /// Removes all of the app's scheduled workouts.
  Future<void> schedulerRemoveAll() {
    throw UnimplementedError('schedulerRemoveAll() has not been implemented.');
  }
}
