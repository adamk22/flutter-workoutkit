/// The kind of a [Workout]. Serialized as the `workoutType` field.
enum WorkoutType {
  /// See [CustomWorkout].
  customWorkout(label: 'Custom Workout'),

  /// See [SingleGoalWorkout].
  singleGoalWorkout(label: 'Single Goal Workout'),

  /// See [PacerWorkout].
  pacerWorkout(label: 'Pacer Workout'),

  /// See [SwimBikeRunWorkout].
  swimBikeRunWorkout(label: 'Swim Bike Run Workout');

  /// Human readable label.
  final String label;

  const WorkoutType({required this.label});

  /// Looks up a workout type by its [name].
  static WorkoutType fromString(String name) => WorkoutType.values.byName(name);
}
