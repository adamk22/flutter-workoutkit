import 'package:workoutkit/enums/WorkoutActivityType.enum.dart';
import 'package:workoutkit/enums/WorkoutLocationType.enum.dart';

class Workout {
  final WorkoutActivityType activityType;
  final WorkoutLocationType location;

  Workout({
    required this.activityType,
    required this.location,
  });
}
