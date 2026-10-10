import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_workoutkit/flutter_workoutkit.dart';

import '../support/random_workouts.dart';
import '../support/samples.dart';
import 'test_helpers.dart';

void main() {
  group('equality', () {
    test('every sample equals its JSON round-trip', () {
      allSamples.forEach((name, sample) {
        final copy = Workout.fromJson(normalize(sample.toJson()));
        expect(copy, sample, reason: name);
        expect(copy.hashCode, sample.hashCode, reason: name);
      });
    });

    test('every random workout equals its JSON round-trip', () {
      for (final workout in generateRandomWorkouts()) {
        final copy = Workout.fromJson(normalize(workout.toJson()));
        expect(copy, workout);
        expect(copy.hashCode, workout.hashCode);
      }
    });

    test('different workouts are not equal', () {
      final all = allSamples.values.toList();
      for (var i = 0; i < all.length; i++) {
        for (var j = i + 1; j < all.length; j++) {
          expect(all[i] == all[j], isFalse);
        }
      }
    });

    test('ints and doubles compare and hash equally', () {
      const a = WorkoutGoal(
          type: WorkoutGoalType.distance,
          targetValue: 5,
          unit: WorkoutGoalUnit.kilometers);
      final b = WorkoutGoal.fromJson(
          {'type': 'distance', 'targetValue': 5.0, 'unit': 'kilometers'});
      expect(a, b);
      expect(a.hashCode, b.hashCode);
    });

    test('alerts of different types are never equal', () {
      final pace = PaceThresholdAlert(pace: const Duration(minutes: 5));
      final speed = SpeedThresholdAlert(
        threshold: pace.thresholdMetersPerSecond,
        unitSpeed: UnitSpeed.metersPerSecond,
        metric: WorkoutAlertMetric.current,
      );
      expect(pace == speed, isFalse);
    });

    test('works in sets and as map keys', () {
      final set = {
        HeartRateZoneAlert(zone: 2),
        HeartRateZoneAlert(zone: 2),
        HeartRateZoneAlert(zone: 3),
      };
      expect(set, hasLength(2));
    });

    test('ScheduledWorkout and WorkoutValidationResult compare by value', () {
      final date = DateTime(2026, 10, 12, 7);
      expect(
        ScheduledWorkout(workout: sampleCustomWorkout, date: date),
        ScheduledWorkout(workout: sampleCustomWorkout, date: date),
      );
      expect(
        const WorkoutValidationResult(isValid: false, issues: ['a']),
        const WorkoutValidationResult(isValid: false, issues: ['a']),
      );
    });
  });

  group('copyWith', () {
    test('without arguments returns an equal object', () {
      final objects = <Object>[
        ...allSamples.values.map((w) => switch (w) {
              CustomWorkout() => w.copyWith(),
              PacerWorkout() => w.copyWith(),
              SingleGoalWorkout() => w.copyWith(),
              SwimBikeRunWorkout() => w.copyWith(),
              _ => throw StateError('unknown workout'),
            }),
      ];
      expect(objects, allSamples.values.toList());
    });

    test('workouts', () {
      final custom = sampleTempoPaceRun.copyWith(displayName: 'Renamed');
      expect(custom.displayName, 'Renamed');
      expect(custom.blocks, sampleTempoPaceRun.blocks);
      expect(custom == sampleTempoPaceRun, isFalse);

      final pacer = samplePacerMinutesWorkout.copyWith(targetValue: 2000);
      expect(pacer.targetValue, 2000);
      expect(pacer.targetDuration, samplePacerMinutesWorkout.targetDuration);

      final single = sampleSingleGoalTimedWorkout.copyWith(
          id: 'A-B', goal: const WorkoutGoal.open());
      expect(single.id, 'A-B');
      expect(single.goal, const WorkoutGoal.open());
      expect(single.location, sampleSingleGoalTimedWorkout.location);

      final multi = sampleSwimBikeRunWorkout.copyWith(displayName: 'Tri');
      expect(multi.activities, sampleSwimBikeRunWorkout.activities);
      expect(multi.displayName, 'Tri');
    });

    test('parts', () {
      final step = WorkoutStep(goal: const WorkoutGoal.open()).copyWith(
        displayName: 'Go',
        alert: HeartRateZoneAlert(zone: 2),
      );
      expect(step.displayName, 'Go');
      expect(step.alert, HeartRateZoneAlert(zone: 2));

      const goal = WorkoutGoal.time(Duration(minutes: 5));
      expect(goal.copyWith(unit: WorkoutGoalUnit.seconds).unit,
          WorkoutGoalUnit.seconds);
      expect(goal.copyWith(unit: WorkoutGoalUnit.seconds).targetDuration,
          goal.targetDuration);

      final interval = IntervalStep(
          purpose: IntervalStepPurpose.work, goal: const WorkoutGoal.open());
      expect(interval.copyWith(purpose: IntervalStepPurpose.recovery).purpose,
          IntervalStepPurpose.recovery);

      final block = IntervalBlock(iterations: 2, steps: [interval]);
      expect(block.copyWith(iterations: 5).iterations, 5);
      expect(block.copyWith(iterations: 5).steps, block.steps);

      final leg = MultisportActivity(
          type: MultisportActivityType.running,
          location: WorkoutLocationType.outdoor);
      expect(leg.copyWith(location: WorkoutLocationType.indoor).location,
          WorkoutLocationType.indoor);
    });

    test('alerts', () {
      expect(HeartRateZoneAlert(zone: 1).copyWith(zone: 4).zone, 4);
      expect(
          HeartRateRangeAlert(lowerBound: 100, upperBound: 150)
              .copyWith(upperBound: 160),
          HeartRateRangeAlert(lowerBound: 100, upperBound: 160));
      expect(CadenceRangeAlert(lowerBound: 80, upperBound: 90).copyWith(),
          CadenceRangeAlert(lowerBound: 80, upperBound: 90));
      expect(CadenceThresholdAlert(threshold: 90).copyWith(threshold: 95),
          CadenceThresholdAlert(threshold: 95));
      expect(
          PowerZoneAlert(zone: 2).copyWith(zone: 3), PowerZoneAlert(zone: 3));
      expect(
          PowerRangeAlert(
                  lowerBound: 200,
                  upperBound: 250,
                  metric: WorkoutAlertMetric.current)
              .copyWith(metric: WorkoutAlertMetric.average)
              .metric,
          WorkoutAlertMetric.average);
      expect(
          PowerThresholdAlert(
                  threshold: 200, metric: WorkoutAlertMetric.current)
              .copyWith(threshold: 210)
              .threshold,
          210);
      expect(
          SpeedRangeAlert(
                  lowerBound: 10,
                  upperBound: 12,
                  unitSpeed: UnitSpeed.kilometersPerHour,
                  metric: WorkoutAlertMetric.current)
              .copyWith(unitSpeed: UnitSpeed.milesPerHour)
              .unitSpeed,
          UnitSpeed.milesPerHour);
      expect(
          SpeedThresholdAlert(
                  threshold: 10,
                  unitSpeed: UnitSpeed.kilometersPerHour,
                  metric: WorkoutAlertMetric.current)
              .copyWith(threshold: 11)
              .threshold,
          11);
      final pace = PaceRangeAlert(
        fastestPace: const Duration(minutes: 4),
        slowestPace: const Duration(minutes: 5),
      );
      expect(
          pace.copyWith(paceUnit: PaceUnit.perMile).paceUnit, PaceUnit.perMile);
      expect(
          PaceThresholdAlert(pace: const Duration(minutes: 5))
              .copyWith(pace: const Duration(minutes: 6))
              .pace,
          const Duration(minutes: 6));
    });

    test('ScheduledWorkout', () {
      final s = ScheduledWorkout(
              workout: sampleCustomWorkout, date: DateTime(2026, 10, 12))
          .copyWith(complete: true);
      expect(s.complete, isTrue);
      expect(s.workout, sampleCustomWorkout);
    });
  });
}
