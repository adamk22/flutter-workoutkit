import 'package:flutter_workoutkit/flutter_workoutkit.dart';
import 'package:flutter_workoutkit/src/utils/json.dart';

/// A single step: a goal, an optional alert and an optional display name.
class WorkoutStep {
  /// The goal of the step.
  final WorkoutGoal goal;

  /// The alert of the step.
  final WorkoutAlert? alert;

  /// The display name shown on the Watch. Requires iOS 18.0+; ignored on
  /// iOS 17.
  final String? displayName;

  /// Creates a new workout step.
  WorkoutStep({
    required this.goal,
    this.alert,
    this.displayName,
  });

  /// Converts the workout step to a JSON object.
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{'goal': goal.toJson()};
    putIfNotNull(json, 'alert', alert?.toJson());
    putIfNotNull(json, 'displayName', displayName);
    return json;
  }

  /// Creates a new workout step from a JSON object.
  static WorkoutStep fromJson(Map<String, dynamic> json) {
    return WorkoutStep(
      goal: WorkoutGoal.fromJson(asJsonMap(json['goal'])),
      alert: json['alert'] != null
          ? WorkoutAlert.fromJson(asJsonMap(json['alert']))
          : null,
      displayName: json['displayName'] as String?,
    );
  }
}
