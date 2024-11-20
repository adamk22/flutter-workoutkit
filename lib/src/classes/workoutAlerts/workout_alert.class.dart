import 'package:flutter_workoutkit/workoutkit.dart';

class WorkoutAlert {
  final WorkoutAlertType type;

  WorkoutAlert({required this.type});

  Map<String, dynamic> toJson() {
    return {
      'type': type.toString().split('.').last,
    };
  }
}
