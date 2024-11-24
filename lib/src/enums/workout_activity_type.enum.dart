// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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

  IconData get iconData {
    switch (this) {
      case WorkoutActivityType.archery:
        return Icons.gps_fixed;
      case WorkoutActivityType.badminton:
        return Icons.sports_tennis;
      case WorkoutActivityType.baseball:
        return Icons.sports_baseball;
      case WorkoutActivityType.basketball:
        return Icons.sports_basketball;
      case WorkoutActivityType.bowling:
        return Icons.sports_cricket;
      case WorkoutActivityType.boxing:
        return Icons.sports_mma;
      case WorkoutActivityType.climbing:
        return Icons.terrain;
      case WorkoutActivityType.crossTraining:
        return Icons.fitness_center;
      case WorkoutActivityType.cycling:
        return Icons.directions_bike;
      case WorkoutActivityType.dance:
        return Icons.music_note;
      case WorkoutActivityType.elliptical:
        return Icons.fitness_center;
      case WorkoutActivityType.fitnessGaming:
        return Icons.sports_esports;
      case WorkoutActivityType.functionalStrengthTraining:
        return Icons.fitness_center;
      case WorkoutActivityType.golf:
        return Icons.sports_golf;
      case WorkoutActivityType.hiking:
        return Icons.terrain;
      case WorkoutActivityType.hockey:
        return Icons.sports_hockey;
      case WorkoutActivityType.jumpRope:
        return Icons.loop;
      case WorkoutActivityType.kickboxing:
        return Icons.sports_kabaddi;
      case WorkoutActivityType.martialArts:
        return Icons.sports_martial_arts;
      case WorkoutActivityType.pilates:
        return Icons.self_improvement;
      case WorkoutActivityType.rowing:
        return Icons.rowing;
      case WorkoutActivityType.rugby:
        return Icons.sports_rugby;
      case WorkoutActivityType.running:
        return Icons.directions_run;
      case WorkoutActivityType.sailing:
        return Icons.sailing;
      case WorkoutActivityType.skatingSports:
        return Icons.ice_skating;
      case WorkoutActivityType.soccer:
        return Icons.sports_soccer;
      case WorkoutActivityType.stairs:
        return Icons.stairs;
      case WorkoutActivityType.swimming:
        return Icons.pool;
      case WorkoutActivityType.tableTennis:
        return Icons.sports_tennis;
      case WorkoutActivityType.tennis:
        return Icons.sports_tennis;
      case WorkoutActivityType.volleyball:
        return Icons.sports_volleyball;
      case WorkoutActivityType.walking:
        return Icons.directions_walk;
      case WorkoutActivityType.waterFitness:
        return Icons.pool;
      case WorkoutActivityType.waterPolo:
        return Icons.pool;
      case WorkoutActivityType.waterSports:
        return Icons.surfing;
      case WorkoutActivityType.wrestling:
        return Icons.sports_kabaddi;
      case WorkoutActivityType.yoga:
        return Icons.self_improvement;
    }
  }
}

// Extension to capitalize first letter of a string
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
