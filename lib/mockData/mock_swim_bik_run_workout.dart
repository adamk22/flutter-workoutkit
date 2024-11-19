import 'package:flutter_workoutkit/workoutkit.dart';

final SwimBikeRunWorkout mockSwimBikeRunWorkout = SwimBikeRunWorkout(
  displayName: 'Triathlon Training',
  activities: [
    MultisportActivity(
      type: MultisportActivityType.swimming,
      swimmingLocation: WorkoutSwimmingLocationType.pool,
    ),
    MultisportActivity(
      type: MultisportActivityType.cycling,
      location: WorkoutLocationType.outdoor,
    ),
    MultisportActivity(
      type: MultisportActivityType.running,
      location: WorkoutLocationType.outdoor,
    ),
  ],
);
