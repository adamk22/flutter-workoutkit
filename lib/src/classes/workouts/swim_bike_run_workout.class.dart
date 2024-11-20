import 'package:flutter_workoutkit/workoutkit.dart';

/// Represents a swim bike run workout
class SwimBikeRunWorkout extends Workout {
  /// The display name of the workout (optional)
  final String? displayName;

  /// The activities of the workout
  final List<MultisportActivity> activities;

  /// Creates a new swim bike run workout
  SwimBikeRunWorkout({
    required this.activities,
    this.displayName,
  }) : super(workoutType: WorkoutType.swimBikeRunWorkout);

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json['activities'] =
        activities.map((activity) => activity.toJson()).toList();
    if (displayName != null) {
      json['displayName'] = displayName;
    }
    return json;
  }
}
