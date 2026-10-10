import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_workoutkit/flutter_workoutkit.dart';

void main() {
  group('WorkoutGoal asserts', () {
    test('distance needs a targetValue', () {
      expect(() => WorkoutGoal(type: WorkoutGoalType.distance),
          throwsA(isA<AssertionError>()));
    });

    test('time needs a targetDuration', () {
      expect(() => WorkoutGoal(type: WorkoutGoalType.time),
          throwsA(isA<AssertionError>()));
    });

    test('pool swim needs distance, unit and duration', () {
      expect(
        () => WorkoutGoal(
            type: WorkoutGoalType.poolSwimDistanceWithTime, targetValue: 100),
        throwsA(isA<AssertionError>()),
      );
    });

    test('time goals default to minutes', () {
      expect(const WorkoutGoal.time(Duration(minutes: 3)).toJson(),
          {'type': 'time', 'targetDuration': 180, 'unit': 'minutes'});
    });
  });

  test('IntervalStep needs exactly one of goal and step', () {
    expect(() => IntervalStep(purpose: IntervalStepPurpose.work),
        throwsA(isA<AssertionError>()));
    expect(
      () => IntervalStep(
        purpose: IntervalStepPurpose.work,
        goal: const WorkoutGoal.open(),
        step: WorkoutStep(goal: const WorkoutGoal.open()),
      ),
      throwsA(isA<AssertionError>()),
    );
  });

  test('SingleGoalWorkout checks swimming vs. other locations', () {
    expect(
      () => SingleGoalWorkout(
        activityType: WorkoutActivityType.swimming,
        location: WorkoutLocationType.indoor,
        goal: const WorkoutGoal.open(),
      ),
      throwsArgumentError,
    );
    expect(
      () => SingleGoalWorkout(
        activityType: WorkoutActivityType.running,
        swimmingLocation: WorkoutSwimmingLocationType.pool,
        goal: const WorkoutGoal.open(),
      ),
      throwsArgumentError,
    );
  });

  test('MultisportActivity needs the matching location', () {
    expect(() => MultisportActivity(type: MultisportActivityType.swimming),
        throwsA(isA<AssertionError>()));
    expect(() => MultisportActivity(type: MultisportActivityType.running),
        throwsA(isA<AssertionError>()));
  });

  test('alert bounds and zones are checked', () {
    expect(() => HeartRateRangeAlert(lowerBound: 150, upperBound: 120),
        throwsA(isA<AssertionError>()));
    expect(() => HeartRateZoneAlert(zone: 6), throwsA(isA<AssertionError>()));
    expect(() => IntervalBlock(iterations: 0, steps: []),
        throwsA(isA<AssertionError>()));
  });

  test('toJson omits null fields', () {
    final json = WorkoutStep(goal: const WorkoutGoal.open()).toJson();
    expect(json, {
      'goal': {'type': 'open'}
    });
  });

  test('deprecated IntervalBlock.type still round-trips', () {
    final block = IntervalBlock(
      iterations: 1,
      steps: [
        IntervalStep(
            purpose: IntervalStepPurpose.work, goal: const WorkoutGoal.open())
      ],
      // ignore: deprecated_member_use_from_same_package
      type: IntervalBlockType.work,
    );
    expect(block.toJson()['type'], 'work');
    expect(IntervalBlock.fromJson(block.toJson()).toJson(), block.toJson());
  });

  test('samples serialize and round-trip', () {
    final samples = <Workout>[
      sampleSpeedCyclingWorkout,
      sampleCustomWorkout,
      sample10kTrainingRun,
      sample21kmTrainingRun,
      sampleTempoPaceRun,
      samplePacerMinutesWorkout,
      samplePacerHoursWorkout,
      sampleSingleGoalTimedWorkout,
      sampleSingleGoalEnergyWorkout,
      sampleSingleOpenWorkout,
      sampleSingleGoalSwimmingWorkout,
      samplePoolSwimIntervals,
      sampleSwimBikeRunWorkout,
    ];
    for (final sample in samples) {
      expect(Workout.fromJson(sample.toJson()).toJson(), sample.toJson());
    }
  });
}
