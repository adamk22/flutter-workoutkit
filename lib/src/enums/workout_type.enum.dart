// ignore_for_file: public_member_api_docs

enum WorkoutType {
  customWorkout(label: 'Custom Workout'),
  singleGoalWorkout(label: 'Single Goal Workout'),
  pacerWorkout(label: 'Pacer Workout'),
  swimBikeRunWorkout(label: 'Swim Bike Run Workout');

  final String label;
  const WorkoutType({required this.label});
}
