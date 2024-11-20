enum WorkoutType {
  customWorkout,
  singleGoalWorkout,
  pacerWorkout,
  swimBikeRunWorkout;

  String toDisplayString() {
    switch (this) {
      case WorkoutType.customWorkout:
        return 'Custom Workout';
      case WorkoutType.singleGoalWorkout:
        return 'Single Goal Workout';
      case WorkoutType.pacerWorkout:
        return 'Pacer Workout';
      case WorkoutType.swimBikeRunWorkout:
        return 'Swim Bike Run Workout';
    }
  }
}
