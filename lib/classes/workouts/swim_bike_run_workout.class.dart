import 'package:flutter_workoutkit/workoutkit.dart';

class SwimBikeRunWorkout extends Workout {
  final String? displayName;
  final List<MultisportActivity> activities;

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
