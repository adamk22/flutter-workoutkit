enum WorkoutActivityType {
  archery,
  badminton,
  baseball,
  basketball,
  bowling,
  boxing,
  climbing,
  crossTraining,
  cycling,
  dance,
  elliptical,
  fitnessGaming,
  functionalStrengthTraining,
  golf,
  hiking,
  hockey,
  jumpRope,
  kickboxing,
  martialArts,
  pilates,
  rowing,
  rugby,
  running,
  sailing,
  skatingSports,
  soccer,
  stairs,
  swimming,
  tableTennis,
  tennis,
  volleyball,
  walking,
  waterFitness,
  waterPolo,
  waterSports,
  wrestling,
  yoga;

  // Convert enum to string representation
  String toDisplayString() {
    switch (this) {
      case WorkoutActivityType.crossTraining:
        return 'Cross Training';
      case WorkoutActivityType.functionalStrengthTraining:
        return 'Strength Training';
      case WorkoutActivityType.skatingSports:
        return 'Skating';
      case WorkoutActivityType.tableTennis:
        return 'Table Tennis';
      case WorkoutActivityType.waterFitness:
        return 'Water Fitness';
      case WorkoutActivityType.fitnessGaming:
        return 'Fitness Gaming';
      case WorkoutActivityType.waterPolo:
        return 'Water Polo';
      case WorkoutActivityType.waterSports:
        return 'Water Sports';
      default:
        // Capitalize first letter and add spaces before capital letters
        return name
            .replaceAllMapped(
              RegExp(r'([A-Z])'),
              (match) => ' ${match.group(0)}',
            )
            .trim()
            .capitalize();
    }
  }
}

// Extension to capitalize first letter of a string
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
