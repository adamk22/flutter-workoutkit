import 'package:flutter/material.dart';

/// The activity of a workout. Maps to HealthKit's `HKWorkoutActivityType`.
///
/// Not every activity is supported by every workout kind; use
/// `Workoutkit.validate` to check a workout before presenting it.
enum WorkoutActivityType {
  /// Archery.
  archery(label: 'Archery'),

  /// Badminton.
  badminton(label: 'Badminton'),

  /// Baseball.
  baseball(label: 'Baseball'),

  /// Basketball.
  basketball(label: 'Basketball'),

  /// Bowling.
  bowling(label: 'Bowling'),

  /// Boxing.
  boxing(label: 'Boxing'),

  /// Climbing.
  climbing(label: 'Climbing'),

  /// Cross Training.
  crossTraining(label: 'Cross Training'),

  /// Cycling.
  cycling(label: 'Cycling'),

  /// Dance. Sent to WorkoutKit as [cardioDance].
  @Deprecated('Use cardioDance or socialDance')
  dance(label: 'Dance'),

  /// Cardio Dance.
  cardioDance(label: 'Cardio Dance'),

  /// Social Dance.
  socialDance(label: 'Social Dance'),

  /// Elliptical.
  elliptical(label: 'Elliptical'),

  /// Fitness Gaming.
  fitnessGaming(label: 'Fitness Gaming'),

  /// Strength Training.
  functionalStrengthTraining(label: 'Strength Training'),

  /// Golf.
  golf(label: 'Golf'),

  /// Hiking.
  hiking(label: 'Hiking'),

  /// Hockey.
  hockey(label: 'Hockey'),

  /// Jump Rope.
  jumpRope(label: 'Jump Rope'),

  /// Kickboxing.
  kickboxing(label: 'Kickboxing'),

  /// Martial Arts.
  martialArts(label: 'Martial Arts'),

  /// Pilates.
  pilates(label: 'Pilates'),

  /// Rowing.
  rowing(label: 'Rowing'),

  /// Rugby.
  rugby(label: 'Rugby'),

  /// Running.
  running(label: 'Running'),

  /// Sailing.
  sailing(label: 'Sailing'),

  /// Skating.
  skatingSports(label: 'Skating'),

  /// Soccer.
  soccer(label: 'Soccer'),

  /// Stairs.
  stairs(label: 'Stairs'),

  /// Swimming.
  swimming(label: 'Swimming'),

  /// Table Tennis.
  tableTennis(label: 'Table Tennis'),

  /// Tennis.
  tennis(label: 'Tennis'),

  /// Volleyball.
  volleyball(label: 'Volleyball'),

  /// Walking.
  walking(label: 'Walking'),

  /// Water Fitness.
  waterFitness(label: 'Water Fitness'),

  /// Water Polo.
  waterPolo(label: 'Water Polo'),

  /// Water Sports.
  waterSports(label: 'Water Sports'),

  /// Wrestling.
  wrestling(label: 'Wrestling'),

  /// Yoga.
  yoga(label: 'Yoga');

  /// Human readable label.
  final String label;

  const WorkoutActivityType({required this.label});

  /// Looks up an activity by its [name].
  static WorkoutActivityType fromString(String name) =>
      WorkoutActivityType.values.byName(name);

  /// A Material icon representing the activity.
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
      // ignore: deprecated_member_use_from_same_package
      case WorkoutActivityType.dance:
      case WorkoutActivityType.cardioDance:
      case WorkoutActivityType.socialDance:
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
