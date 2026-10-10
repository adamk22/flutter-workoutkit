// Regression tests against flutter_workoutkit 0.0.11.
//
// `test/fixtures/legacy_0.0.11/*.json` was produced by running the 0.0.11
// code (git tag/commit 2ad49c4) and must never be regenerated.
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_workoutkit/flutter_workoutkit.dart';

import '../models/test_helpers.dart';
import 'legacy_samples_0_0_11.dart';

final Map<String, Workout> legacySourceSamples = {
  'sampleSingleGoalTimedWorkout': legacySampleSingleGoalTimedWorkout,
  'sampleSingleGoalEnergyWorkout': legacySampleSingleGoalEnergyWorkout,
  'sampleSingleOpenWorkout': legacySampleSingleOpenWorkout,
  'sampleSingleGoalSwimmingWorkout': legacySampleSingleGoalSwimmingWorkout,
  'samplePacerMinutesWorkout': legacySamplePacerMinutesWorkout,
  'samplePacerHoursWorkout': legacySamplePacerHoursWorkout,
  'sampleSpeedCyclingWorkout': legacySampleSpeedCyclingWorkout,
  'sampleCustomWorkout': legacySampleCustomWorkout,
  'sample10kTrainingRun': legacySample10kTrainingRun,
  'sample21kmTrainingRun': legacySample21kmTrainingRun,
  'sampleSwimBikeRunWorkout': legacySampleSwimBikeRunWorkout,
};

void main() {
  final legacySamples = loadFixture('legacy_0.0.11/samples.json') as Map;
  final legacyAlerts = loadFixture('legacy_0.0.11/alerts.json') as List;

  group('0.0.11 source code', () {
    test('still compiles and serializes exactly like 0.0.11 (minus nulls)', () {
      expect(legacySourceSamples.keys, unorderedEquals(legacySamples.keys));
      legacySourceSamples.forEach((name, workout) {
        expect(normalize(workout.toJson()), stripNulls(legacySamples[name]),
            reason: name);
      });
    });

    test('public APIs used by 0.0.11 apps still exist', () {
      // Compile-time checks: these only need to type-check.
      final Future<void> Function() request =
          Workoutkit.requestHealthPermissions;
      final Future<bool> Function() has = Workoutkit.hasHealthPermissions;
      final Future<String?> Function() version = Workoutkit.getPlatformVersion;
      expect([request, has, version], hasLength(3));

      final button = WorkoutPreviewButton(
        workout: legacySampleCustomWorkout,
        buttonTitle: 'Preview',
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        cornerRadiusSize: 10,
        buttonHeight: 54,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      );
      expect(button.workout, legacySampleCustomWorkout);

      expect(WorkoutAlert.fromJson(HeartRateZoneAlert(zone: 1).toJson()),
          isA<HeartRateZoneAlert>());
      expect(HeartRateZoneAlert(zone: 3).toDisplayString(), 'HR Zone 3');
      expect(WorkoutActivityType.running.iconData, Icons.directions_run);
    });

    test('every 0.0.11 enum value still exists with the same name', () {
      const legacyEnums = <String, List<String>>{
        'MultisportActivityType': ['cycling', 'running', 'swimming'],
        'WorkoutGoalType': ['distance', 'time', 'energy', 'open'],
        'GoalDistanceUnits': ['kilometers', 'miles', 'meters', 'yards'],
        'GoalTimeUnits': ['minutes', 'hours', 'seconds'],
        'GoalEnergyUnits': ['calories', 'kilocalories'],
        'WorkoutGoalUnit': [
          'kilometers',
          'miles',
          'meters',
          'yards',
          'minutes',
          'hours',
          'seconds',
          'calories',
          'kilocalories',
          'open'
        ],
        'UnitSpeed': [
          'metersPerSecond',
          'kilometersPerHour',
          'milesPerHour',
          'knots'
        ],
        'WorkoutAlertType': [
          'cadenceRange',
          'cadenceThreshold',
          'heartRateRange',
          'heartRateZone',
          'powerRange',
          'powerThreshold',
          'powerZone',
          'speedRange',
          'speedThreshold',
          'paceRange',
          'paceThreshold'
        ],
        'WorkoutActivityType': [
          'archery',
          'badminton',
          'baseball',
          'basketball',
          'bowling',
          'boxing',
          'climbing',
          'crossTraining',
          'cycling',
          'dance',
          'elliptical',
          'fitnessGaming',
          'functionalStrengthTraining',
          'golf',
          'hiking',
          'hockey',
          'jumpRope',
          'kickboxing',
          'martialArts',
          'pilates',
          'rowing',
          'rugby',
          'running',
          'sailing',
          'skatingSports',
          'soccer',
          'stairs',
          'swimming',
          'tableTennis',
          'tennis',
          'volleyball',
          'walking',
          'waterFitness',
          'waterPolo',
          'waterSports',
          'wrestling',
          'yoga'
        ],
        'WorkoutLocationType': ['unknown', 'indoor', 'outdoor'],
        'WorkoutAlertMetric': ['average', 'current'],
        'WorkoutSwimmingLocationType': ['unknown', 'openWater', 'pool'],
        'WorkoutType': [
          'customWorkout',
          'singleGoalWorkout',
          'pacerWorkout',
          'swimBikeRunWorkout'
        ],
        'IntervalBlockType': ['work', 'recovery', 'workRecovery'],
        'IntervalStepPurpose': ['work', 'recovery'],
      };
      final current = <String, List<Enum>>{
        'MultisportActivityType': MultisportActivityType.values,
        'WorkoutGoalType': WorkoutGoalType.values,
        'GoalDistanceUnits': GoalDistanceUnits.values,
        'GoalTimeUnits': GoalTimeUnits.values,
        'GoalEnergyUnits': GoalEnergyUnits.values,
        'WorkoutGoalUnit': WorkoutGoalUnit.values,
        'UnitSpeed': UnitSpeed.values,
        'WorkoutAlertType': WorkoutAlertType.values,
        'WorkoutActivityType': WorkoutActivityType.values,
        'WorkoutLocationType': WorkoutLocationType.values,
        'WorkoutAlertMetric': WorkoutAlertMetric.values,
        'WorkoutSwimmingLocationType': WorkoutSwimmingLocationType.values,
        'WorkoutType': WorkoutType.values,
        'IntervalBlockType': IntervalBlockType.values,
        'IntervalStepPurpose': IntervalStepPurpose.values,
      };
      legacyEnums.forEach((name, values) {
        expect(current[name]!.map((e) => e.name), containsAll(values),
            reason: name);
      });
    });
  });

  group('0.0.11 serialized JSON', () {
    test('every legacy workout parses and keeps its data', () {
      for (final entry in legacySamples.entries) {
        final legacy = Map<String, dynamic>.from(entry.value as Map);
        final workout = Workout.fromJson(legacy);
        expect(normalize(workout.toJson()), stripNulls(legacy),
            reason: entry.key);
      }
    });

    test('every legacy alert parses to its concrete class', () {
      for (final json in legacyAlerts) {
        final alert = WorkoutAlert.fromJson(Map<String, dynamic>.from(json));
        expect(alert.type.name, json['type']);
        expect(alert.runtimeType.toString(), isNot('WorkoutAlert'));
        expect(normalize(alert.toJson()), stripNulls(json));
      }
    });

    test('legacy samples describe the same workouts as the current samples',
        () {
      // Samples whose definition intentionally changed in 1.0.0.
      const changed = {'sampleSingleGoalEnergyWorkout'};
      for (final entry in legacySamples.entries) {
        if (changed.contains(entry.key)) continue;
        final legacy = stripNulls(entry.value) as Map;
        final current =
            normalize(loadFixture('samples.json')[entry.key]) as Map;
        expect(_withoutBlockTypes(legacy), _withoutBlockTypes(current),
            reason: entry.key);
      }
    });
  });
}

/// IntervalBlock.type is deprecated and no longer set by the samples.
dynamic _withoutBlockTypes(Object? json) {
  if (json is Map) {
    return {
      for (final e in json.entries)
        if (!(e.key == 'type' && json.containsKey('iterations')))
          e.key: _withoutBlockTypes(e.value),
    };
  }
  if (json is List) return json.map(_withoutBlockTypes).toList();
  return json;
}
