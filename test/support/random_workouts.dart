import 'dart:math';

import 'package:flutter_workoutkit/flutter_workoutkit.dart';

/// Deterministically generates [count] valid-in-Dart workouts that cover
/// every workout type, goal, alert, unit and activity, including many
/// combinations WorkoutKit does not support.
///
/// The output is checked in as `test/fixtures/random_workouts.json` and fed to
/// the Swift tests, which must never crash on any of them.
List<Workout> generateRandomWorkouts({int count = 300, int seed = 20261010}) {
  final r = Random(seed);
  T pick<T>(List<T> values) => values[r.nextInt(values.length)];
  bool chance(double p) => r.nextDouble() < p;
  double value(double min, double max) =>
      ((min + r.nextDouble() * (max - min)) * 100).roundToDouble() / 100;
  Duration seconds(int min, int max) =>
      Duration(seconds: min + r.nextInt(max - min + 1));

  String uuid() {
    String hex(int n) =>
        List.generate(n, (_) => r.nextInt(16).toRadixString(16).toUpperCase())
            .join();
    return '${hex(8)}-${hex(4)}-4${hex(3)}-A${hex(3)}-${hex(12)}';
  }

  const distanceUnits = [
    WorkoutGoalUnit.meters,
    WorkoutGoalUnit.kilometers,
    WorkoutGoalUnit.miles,
    WorkoutGoalUnit.yards,
  ];
  const timeUnits = [
    WorkoutGoalUnit.seconds,
    WorkoutGoalUnit.minutes,
    WorkoutGoalUnit.hours,
  ];
  const energyUnits = [WorkoutGoalUnit.calories, WorkoutGoalUnit.kilocalories];

  WorkoutGoal goal() {
    switch (r.nextInt(5)) {
      case 0:
        return const WorkoutGoal.open();
      case 1:
        return WorkoutGoal.distance(value(0.1, 50), pick(distanceUnits));
      case 2:
        return WorkoutGoal.time(seconds(10, 7200), unit: pick(timeUnits));
      case 3:
        return WorkoutGoal.energy(value(10, 1000), unit: pick(energyUnits));
      default:
        return WorkoutGoal.poolSwimDistanceWithTime(
          distance: value(25, 2000),
          distanceUnit: pick([WorkoutGoalUnit.meters, WorkoutGoalUnit.yards]),
          duration: seconds(30, 3600),
          durationUnit: pick(timeUnits),
        );
    }
  }

  WorkoutAlert alert() {
    final metric = pick(WorkoutAlertMetric.values);
    switch (r.nextInt(11)) {
      case 0:
        return HeartRateZoneAlert(zone: 1 + r.nextInt(5));
      case 1:
        final low = value(60, 160);
        return HeartRateRangeAlert(
            lowerBound: low, upperBound: low + value(5, 40));
      case 2:
        final low = value(60, 180);
        return CadenceRangeAlert(
            lowerBound: low, upperBound: low + value(5, 30));
      case 3:
        return CadenceThresholdAlert(threshold: value(60, 200));
      case 4:
        return PowerZoneAlert(zone: 1 + r.nextInt(5));
      case 5:
        final low = value(80, 300);
        return PowerRangeAlert(
            lowerBound: low, upperBound: low + value(10, 100), metric: metric);
      case 6:
        return PowerThresholdAlert(threshold: value(80, 400), metric: metric);
      case 7:
        final low = value(5, 30);
        return SpeedRangeAlert(
          lowerBound: low,
          upperBound: low + value(1, 10),
          unitSpeed: pick(UnitSpeed.values),
          metric: metric,
        );
      case 8:
        return SpeedThresholdAlert(
            threshold: value(5, 40),
            unitSpeed: pick(UnitSpeed.values),
            metric: metric);
      case 9:
        final fastest = seconds(150, 420);
        return PaceRangeAlert(
          fastestPace: fastest,
          slowestPace: fastest + seconds(5, 60),
          paceUnit: pick(PaceUnit.values),
          metric: metric,
        );
      default:
        return PaceThresholdAlert(
            pace: seconds(150, 600),
            paceUnit: pick(PaceUnit.values),
            metric: metric);
    }
  }

  WorkoutStep step() => WorkoutStep(
        goal: goal(),
        alert: chance(0.6) ? alert() : null,
        displayName: chance(0.3) ? 'Step ${r.nextInt(100)}' : null,
      );

  IntervalStep intervalStep() {
    final purpose = pick(IntervalStepPurpose.values);
    return chance(0.3)
        ? IntervalStep(purpose: purpose, step: step())
        : IntervalStep(
            purpose: purpose,
            goal: goal(),
            alert: chance(0.6) ? alert() : null);
  }

  Workout workout(int i) {
    final id = chance(0.3) ? uuid() : null;
    final activity = pick(WorkoutActivityType.values);
    final location = pick(WorkoutLocationType.values);
    switch (i % 4) {
      case 0:
        return CustomWorkout(
          id: id,
          activityType: activity,
          location: location,
          displayName: 'Random $i',
          warmup: chance(0.5) ? step() : null,
          blocks: List.generate(
            1 + r.nextInt(3),
            (_) => IntervalBlock(
              iterations: 1 + r.nextInt(5),
              steps: List.generate(1 + r.nextInt(3), (_) => intervalStep()),
            ),
          ),
          cooldown: chance(0.5) ? step() : null,
        );
      case 1:
        final swimming = activity == WorkoutActivityType.swimming;
        return SingleGoalWorkout(
          id: id,
          activityType: activity,
          location: swimming ? null : location,
          swimmingLocation:
              swimming ? pick(WorkoutSwimmingLocationType.values) : null,
          goal: goal(),
        );
      case 2:
        return PacerWorkout(
          id: id,
          activityType: activity,
          location: location,
          targetValue: value(0.5, 50),
          targetValueUnit: pick(GoalDistanceUnits.values),
          targetDuration: seconds(60, 18000),
          targetDurationUnit: pick(GoalTimeUnits.values),
        );
      default:
        return SwimBikeRunWorkout(
          id: id,
          displayName: chance(0.5) ? 'Multisport $i' : null,
          activities: List.generate(1 + r.nextInt(4), (_) {
            final type = pick(MultisportActivityType.values);
            return type == MultisportActivityType.swimming
                ? MultisportActivity(
                    type: type,
                    swimmingLocation: pick(WorkoutSwimmingLocationType.values))
                : MultisportActivity(type: type, location: location);
          }),
        );
    }
  }

  return List.generate(count, workout);
}
