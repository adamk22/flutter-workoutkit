import '../../enums/index.dart';
import 'custom_workout.dart';
import 'pacer_workout.dart';
import 'single_goal_workout.dart';
import 'swim_bike_run_workout.dart';

/// Base class for all workout types.
abstract class Workout {
  /// The type of workout this represents.
  final WorkoutType workoutType;

  /// A stable identifier (UUID string) for the workout plan.
  ///
  /// Optional when previewing. WorkoutKit assigns one when it is missing, and
  /// workouts returned by `WorkoutScheduler` always have one.
  final String? id;

  /// Creates a new workout.
  Workout({
    required this.workoutType,
    this.id,
  });

  /// Converts the workout to a JSON object.
  Map<String, dynamic> toJson() {
    return {
      'workoutType': workoutType.name,
      if (id != null) 'id': id,
    };
  }

  /// Creates the concrete workout described by [json]'s `workoutType`.
  factory Workout.fromJson(Map<String, dynamic> json) {
    switch (WorkoutType.fromString(json['workoutType'] as String)) {
      case WorkoutType.customWorkout:
        return CustomWorkout.fromJson(json);
      case WorkoutType.singleGoalWorkout:
        return SingleGoalWorkout.fromJson(json);
      case WorkoutType.pacerWorkout:
        return PacerWorkout.fromJson(json);
      case WorkoutType.swimBikeRunWorkout:
        return SwimBikeRunWorkout.fromJson(json);
    }
  }
}
