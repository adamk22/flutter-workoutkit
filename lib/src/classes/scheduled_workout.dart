import 'package:flutter_workoutkit/src/utils/json.dart';

import 'workouts/base_workout.dart';
import 'package:flutter_workoutkit/src/utils/json_equality.dart';

/// Whether the app may schedule workouts on the user's Apple Watch.
enum SchedulerAuthorizationState {
  /// The user hasn't been asked yet.
  notDetermined,

  /// Scheduling is restricted, e.g. by parental controls.
  restricted,

  /// The user denied access.
  denied,

  /// The app may schedule workouts.
  authorized,
}

/// A workout scheduled on the user's Apple Watch.
class ScheduledWorkout with JsonValueEquality {
  /// The scheduled workout. Its [Workout.id] identifies the plan.
  final Workout workout;

  /// The scheduled date (local time, minute precision).
  final DateTime date;

  /// Whether the workout was marked complete.
  final bool complete;

  /// Creates a new scheduled workout.
  const ScheduledWorkout({
    required this.workout,
    required this.date,
    this.complete = false,
  });

  /// The plan id of [workout].
  String get id => workout.id!;

  /// Returns a copy with the given fields replaced.
  ScheduledWorkout copyWith(
          {Workout? workout, DateTime? date, bool? complete}) =>
      ScheduledWorkout(
        workout: workout ?? this.workout,
        date: date ?? this.date,
        complete: complete ?? this.complete,
      );

  /// Creates a scheduled workout from the native response.
  factory ScheduledWorkout.fromJson(Map<String, dynamic> json) =>
      ScheduledWorkout(
        workout: Workout.fromJson(asJsonMap(json['workout'])),
        date: dateFromComponents(asJsonMap(json['date'])),
        complete: json['complete'] as bool? ?? false,
      );

  /// Converts the scheduled workout to a JSON object.
  @override
  Map<String, dynamic> toJson() => {
        'workout': workout.toJson(),
        'date': dateToComponents(date),
        'complete': complete,
      };
}

/// Converts a local [DateTime] to the date components sent to WorkoutKit.
Map<String, int> dateToComponents(DateTime date) {
  final local = date.toLocal();
  return {
    'year': local.year,
    'month': local.month,
    'day': local.day,
    'hour': local.hour,
    'minute': local.minute,
  };
}

/// Converts date components from WorkoutKit to a local [DateTime].
DateTime dateFromComponents(Map<String, dynamic> components) => DateTime(
      (components['year'] as num).toInt(),
      (components['month'] as num?)?.toInt() ?? 1,
      (components['day'] as num?)?.toInt() ?? 1,
      (components['hour'] as num?)?.toInt() ?? 0,
      (components['minute'] as num?)?.toInt() ?? 0,
    );
