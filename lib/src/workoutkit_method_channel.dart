import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'classes/index.dart';
import 'classes/scheduled_workout.dart' show dateToComponents;
import 'utils/json.dart';
import 'workoutkit_exception.dart';
import 'workoutkit_platform_interface.dart';

/// An implementation of [WorkoutkitPlatform] that uses method channels.
class MethodChannelWorkoutkit extends WorkoutkitPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('workoutkit');

  Future<T?> _invoke<T>(String method, [Object? arguments]) async {
    try {
      return await methodChannel.invokeMethod<T>(method, arguments);
    } on PlatformException catch (e) {
      throw WorkoutkitException.fromPlatformException(e);
    }
  }

  @override
  Future<String?> getPlatformVersion() => _invoke<String>('getPlatformVersion');

  @override
  Future<void> requestHealthPermissions() =>
      _invoke<void>('requestHealthPermissions');

  @override
  Future<bool> hasHealthPermissions() async =>
      await _invoke<bool>('hasHealthPermissions') ?? false;

  @override
  Future<WorkoutValidationResult> validateWorkout(Workout workout) async {
    final result = await _invoke<Map>('validate', workout.toJson());
    return WorkoutValidationResult.fromJson(asJsonMap(result));
  }

  @override
  Future<Uint8List> exportWorkout(Workout workout) async =>
      (await _invoke<Uint8List>('exportPlan', workout.toJson()))!;

  @override
  Future<Workout> importWorkout(Uint8List data) async =>
      Workout.fromJson(asJsonMap(await _invoke<Map>('importPlan', data)));

  @override
  Future<void> presentPreview(Workout workout) async {
    try {
      await _invoke<void>('presentPreview', workout.toJson());
    } on MissingPluginException {
      throw const WorkoutkitException(
        WorkoutkitErrorCode.unsupportedPlatform,
        'presentPreview is only available on iOS',
      );
    }
  }

  @override
  Future<bool> schedulerIsSupported() async =>
      await _invoke<bool>('scheduler.isSupported') ?? false;

  @override
  Future<SchedulerAuthorizationState> schedulerAuthorizationState() async =>
      SchedulerAuthorizationState.values
          .byName((await _invoke<String>('scheduler.authorizationState'))!);

  @override
  Future<SchedulerAuthorizationState> schedulerRequestAuthorization() async =>
      SchedulerAuthorizationState.values
          .byName((await _invoke<String>('scheduler.requestAuthorization'))!);

  @override
  Future<int> schedulerMaxAllowedScheduledWorkoutCount() async =>
      (await _invoke<int>('scheduler.maxAllowedScheduledWorkoutCount'))!;

  @override
  Future<ScheduledWorkout> schedulerSchedule(
      Workout workout, DateTime date) async {
    final result = await _invoke<Map>('scheduler.schedule', {
      'workout': workout.toJson(),
      'date': dateToComponents(date),
    });
    return ScheduledWorkout.fromJson(asJsonMap(result));
  }

  @override
  Future<List<ScheduledWorkout>> schedulerScheduledWorkouts() async {
    final result = await _invoke<List>('scheduler.scheduledWorkouts');
    return asJsonList(result).map(ScheduledWorkout.fromJson).toList();
  }

  @override
  Future<void> schedulerRemove(String id, DateTime date) =>
      _invoke<void>('scheduler.remove', {
        'id': id,
        'date': dateToComponents(date),
      });

  @override
  Future<void> schedulerMarkComplete(String id, DateTime date) =>
      _invoke<void>('scheduler.markComplete', {
        'id': id,
        'date': dateToComponents(date),
      });

  @override
  Future<void> schedulerRemoveAll() => _invoke<void>('scheduler.removeAll');
}
