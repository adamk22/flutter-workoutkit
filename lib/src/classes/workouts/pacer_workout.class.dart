import 'package:flutter_workoutkit/workoutkit.dart';

class PacerWorkout extends Workout {
  final WorkoutActivityType activityType;
  final WorkoutLocationType location;
  final double targetValue;
  final GoalDistanceUnits targetValueUnit;
  final Duration targetDuration;
  final GoalTimeUnits targetDurationUnit;

  PacerWorkout({
    required this.activityType,
    required this.location,
    required this.targetValue,
    required this.targetValueUnit,
    required this.targetDuration,
    required this.targetDurationUnit,
  }) : super(workoutType: WorkoutType.pacerWorkout);

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'activityType': activityType.toString().split('.').last,
      'location': location.toString().split('.').last,
      'targetValue': targetValue,
      'targetValueUnit': targetValueUnit.toString().split('.').last,
      'targetDuration': targetDuration.inSeconds,
      'targetDurationUnit': targetDurationUnit.toString().split('.').last,
    };
  }
}
