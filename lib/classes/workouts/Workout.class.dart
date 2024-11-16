import 'package:flutter_workoutkit/enums/WorkoutActivityType.enum.dart';
import 'package:flutter_workoutkit/enums/WorkoutLocationType.enum.dart';
import 'package:flutter_workoutkit/enums/WorkoutType.enum.dart';

class Workout {
  final WorkoutType workoutType;
  final WorkoutActivityType activityType;
  final WorkoutLocationType location;

  Workout({
    required this.workoutType,
    required this.activityType,
    required this.location,
  });
}
