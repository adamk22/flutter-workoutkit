import 'package:flutter_workoutkit/flutter_workoutkit.dart';
import 'package:flutter_workoutkit/src/utils/json.dart';
import 'package:flutter_workoutkit/src/utils/json_equality.dart';

/// A single step: a goal, an optional alert and an optional display name.
class WorkoutStep with JsonValueEquality {
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
  @override
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{'goal': goal.toJson()};
    putIfNotNull(json, 'alert', alert?.toJson());
    putIfNotNull(json, 'displayName', displayName);
    return json;
  }

  /// Returns a copy with the given fields replaced.
  WorkoutStep copyWith({
    WorkoutGoal? goal,
    WorkoutAlert? alert,
    String? displayName,
  }) {
    return WorkoutStep(
      goal: goal ?? this.goal,
      alert: alert ?? this.alert,
      displayName: displayName ?? this.displayName,
    );
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
