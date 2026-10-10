import 'package:flutter_workoutkit/flutter_workoutkit.dart';
import 'package:flutter_workoutkit/src/utils/json.dart';

/// A multisport (triathlon-style) workout made of swimming, cycling and
/// running legs.
class SwimBikeRunWorkout extends Workout {
  /// The display name of the workout (optional).
  final String? displayName;

  /// The legs of the workout, in order.
  final List<MultisportActivity> activities;

  /// Creates a new swim bike run workout.
  SwimBikeRunWorkout({
    required this.activities,
    this.displayName,
    super.id,
  }) : super(workoutType: WorkoutType.swimBikeRunWorkout);

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json['activities'] =
        activities.map((activity) => activity.toJson()).toList();
    putIfNotNull(json, 'displayName', displayName);
    return json;
  }

  /// Creates a new swim bike run workout from a JSON object.
  static SwimBikeRunWorkout fromJson(Map<String, dynamic> json) {
    return SwimBikeRunWorkout(
      id: json['id'] as String?,
      activities: asJsonList(json['activities'])
          .map(MultisportActivity.fromJson)
          .toList(),
      displayName: json['displayName'] as String?,
    );
  }
}
