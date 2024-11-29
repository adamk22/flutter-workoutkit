// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';

enum WorkoutActivityType {
  archery(label: 'Archery'),
  badminton(label: 'Badminton'),
  baseball(label: 'Baseball'),
  basketball(label: 'Basketball'),
  bowling(label: 'Bowling'),
  boxing(label: 'Boxing'),
  climbing(label: 'Climbing'),
  crossTraining(label: 'Cross Training'),
  cycling(label: 'Cycling'),
  dance(label: 'Dance'),
  elliptical(label: 'Elliptical'),
  fitnessGaming(label: 'Fitness Gaming'),
  functionalStrengthTraining(label: 'Strength Training'),
  golf(label: 'Golf'),
  hiking(label: 'Hiking'),
  hockey(label: 'Hockey'),
  jumpRope(label: 'Jump Rope'),
  kickboxing(label: 'Kickboxing'),
  martialArts(label: 'Martial Arts'),
  pilates(label: 'Pilates'),
  rowing(label: 'Rowing'),
  rugby(label: 'Rugby'),
  running(label: 'Running'),
  sailing(label: 'Sailing'),
  skatingSports(label: 'Skating'),
  soccer(label: 'Soccer'),
  stairs(label: 'Stairs'),
  swimming(label: 'Swimming'),
  tableTennis(label: 'Table Tennis'),
  tennis(label: 'Tennis'),
  volleyball(label: 'Volleyball'),
  walking(label: 'Walking'),
  waterFitness(label: 'Water Fitness'),
  waterPolo(label: 'Water Polo'),
  waterSports(label: 'Water Sports'),
  wrestling(label: 'Wrestling'),
  yoga(label: 'Yoga');

  final String label;
  const WorkoutActivityType({required this.label});

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
