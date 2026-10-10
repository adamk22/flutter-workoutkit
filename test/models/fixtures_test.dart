import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_workoutkit/flutter_workoutkit.dart';

import 'test_helpers.dart';

/// Dart models that must serialize to exactly the shared fixtures.
final Map<String, Workout> workoutFixtures = {
  'custom_workout.json': CustomWorkout(
    id: '6F1D5A3E-2B7C-4E8A-9D10-3C5B7A9E1F24',
    activityType: WorkoutActivityType.running,
    location: WorkoutLocationType.outdoor,
    displayName: 'Intervals',
    warmup: WorkoutStep(
      goal: const WorkoutGoal.time(Duration(minutes: 5)),
      alert: HeartRateZoneAlert(zone: 1),
      displayName: 'Easy warmup',
    ),
    blocks: [
      IntervalBlock(iterations: 4, steps: [
        IntervalStep(
          purpose: IntervalStepPurpose.work,
          goal: const WorkoutGoal.distance(1, WorkoutGoalUnit.kilometers),
          alert: HeartRateRangeAlert(lowerBound: 150, upperBound: 170),
        ),
        IntervalStep(
          purpose: IntervalStepPurpose.recovery,
          goal: const WorkoutGoal.time(Duration(seconds: 90),
              unit: WorkoutGoalUnit.seconds),
        ),
      ]),
      IntervalBlock(iterations: 1, steps: [
        IntervalStep(
          purpose: IntervalStepPurpose.work,
          step: WorkoutStep(
            goal: const WorkoutGoal.open(),
            alert: CadenceRangeAlert(lowerBound: 170, upperBound: 185),
            displayName: 'Strides',
          ),
        ),
      ]),
    ],
    cooldown: WorkoutStep(goal: const WorkoutGoal.time(Duration(minutes: 5))),
  ),
  'single_goal_workout.json': SingleGoalWorkout(
    activityType: WorkoutActivityType.cycling,
    location: WorkoutLocationType.outdoor,
    goal: const WorkoutGoal.energy(500),
  ),
  'single_goal_swimming_workout.json': SingleGoalWorkout(
    activityType: WorkoutActivityType.swimming,
    swimmingLocation: WorkoutSwimmingLocationType.pool,
    goal: const WorkoutGoal.distance(1000, WorkoutGoalUnit.meters),
  ),
  'pool_swim_workout.json': CustomWorkout(
    activityType: WorkoutActivityType.swimming,
    location: WorkoutLocationType.indoor,
    displayName: 'Pool Intervals',
    blocks: [
      IntervalBlock(iterations: 4, steps: [
        IntervalStep(
          purpose: IntervalStepPurpose.work,
          goal: const WorkoutGoal.poolSwimDistanceWithTime(
            distance: 100,
            distanceUnit: WorkoutGoalUnit.meters,
            duration: Duration(minutes: 2),
          ),
        ),
        IntervalStep(
          purpose: IntervalStepPurpose.recovery,
          goal: const WorkoutGoal.time(Duration(seconds: 30),
              unit: WorkoutGoalUnit.seconds),
        ),
      ]),
    ],
  ),
  'pacer_workout.json': PacerWorkout(
    activityType: WorkoutActivityType.running,
    location: WorkoutLocationType.outdoor,
    targetValue: 5,
    targetValueUnit: GoalDistanceUnits.kilometers,
    targetDuration: const Duration(minutes: 25),
    targetDurationUnit: GoalTimeUnits.minutes,
  ),
  'swim_bike_run_workout.json': SwimBikeRunWorkout(
    displayName: 'Sprint Triathlon',
    activities: [
      MultisportActivity(
        type: MultisportActivityType.swimming,
        swimmingLocation: WorkoutSwimmingLocationType.openWater,
      ),
      MultisportActivity(
        type: MultisportActivityType.cycling,
        location: WorkoutLocationType.outdoor,
      ),
      MultisportActivity(
        type: MultisportActivityType.running,
        location: WorkoutLocationType.outdoor,
      ),
    ],
  ),
};

final List<WorkoutGoal> goalFixtures = [
  const WorkoutGoal.open(),
  const WorkoutGoal.distance(5, WorkoutGoalUnit.kilometers),
  const WorkoutGoal.distance(400, WorkoutGoalUnit.yards),
  const WorkoutGoal.time(Duration(seconds: 90)),
  const WorkoutGoal.time(Duration(hours: 2), unit: WorkoutGoalUnit.hours),
  const WorkoutGoal.time(Duration(seconds: 45), unit: WorkoutGoalUnit.seconds),
  const WorkoutGoal.energy(250),
  const WorkoutGoal.energy(1000, unit: WorkoutGoalUnit.calories),
];

final List<WorkoutAlert> alertFixtures = [
  HeartRateZoneAlert(zone: 2),
  HeartRateRangeAlert(lowerBound: 120, upperBound: 140),
  CadenceRangeAlert(lowerBound: 80, upperBound: 95),
  CadenceThresholdAlert(threshold: 90),
  PowerZoneAlert(zone: 3),
  PowerRangeAlert(
      lowerBound: 200, upperBound: 250, metric: WorkoutAlertMetric.average),
  PowerThresholdAlert(threshold: 230, metric: WorkoutAlertMetric.current),
  SpeedRangeAlert(
    lowerBound: 28,
    upperBound: 32,
    unitSpeed: UnitSpeed.kilometersPerHour,
    metric: WorkoutAlertMetric.average,
  ),
  SpeedThresholdAlert(
    threshold: 12,
    unitSpeed: UnitSpeed.milesPerHour,
    metric: WorkoutAlertMetric.current,
  ),
  PaceRangeAlert(
    fastestPace: const Duration(minutes: 5),
    slowestPace: const Duration(minutes: 5, seconds: 30),
  ),
  PaceThresholdAlert(
    pace: const Duration(minutes: 7, seconds: 30),
    paceUnit: PaceUnit.perMile,
    metric: WorkoutAlertMetric.average,
  ),
];

void main() {
  group('workout fixtures', () {
    workoutFixtures.forEach((name, workout) {
      test('$name: toJson matches the fixture', () {
        expect(normalize(workout.toJson()), loadFixture(name));
      });

      test('$name: fromJson round-trips', () {
        final fixture = loadFixture(name) as Map<String, dynamic>;
        final decoded = Workout.fromJson(fixture);
        expect(decoded.runtimeType, workout.runtimeType);
        expect(normalize(decoded.toJson()), fixture);
      });
    });
  });

  test('goals.json matches WorkoutGoal.toJson and round-trips', () {
    final fixture = loadFixture('goals.json') as List;
    expect(normalize(goalFixtures.map((g) => g.toJson()).toList()), fixture);
    for (final json in fixture) {
      expect(normalize(WorkoutGoal.fromJson(json).toJson()), json);
    }
  });

  test('alerts.json matches WorkoutAlert.toJson and round-trips', () {
    final fixture = loadFixture('alerts.json') as List;
    expect(normalize(alertFixtures.map((a) => a.toJson()).toList()), fixture);
    for (var i = 0; i < fixture.length; i++) {
      final decoded = WorkoutAlert.fromJson(fixture[i]);
      expect(decoded.runtimeType, alertFixtures[i].runtimeType);
      expect(normalize(decoded.toJson()), fixture[i]);
    }
  });

  test('payloads from the platform channel (Map<Object?, Object?>) decode', () {
    // StandardMessageCodec yields untyped maps and lists.
    Object? untype(Object? value) {
      if (value is Map) {
        return <Object?, Object?>{
          for (final e in value.entries) e.key: untype(e.value)
        };
      }
      if (value is List) return <Object?>[...value.map(untype)];
      return value;
    }

    final fixture = loadFixture('custom_workout.json');
    final decoded =
        Workout.fromJson(Map<String, dynamic>.from(untype(fixture) as Map));
    expect(normalize(decoded.toJson()), fixture);
  });
}
