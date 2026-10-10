import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_workoutkit/flutter_workoutkit.dart';

import '../support/random_workouts.dart';
import 'test_helpers.dart';

void main() {
  final corpus = generateRandomWorkouts();

  test('random_workouts.json golden matches the generator', () {
    // The Swift tests build every workout in this file and must never crash.
    expectJsonGolden(
        corpus.map((w) => w.toJson()).toList(), 'random_workouts.json');
  });

  test('the corpus covers every workout type, goal, alert and activity', () {
    final json = normalize(corpus.map((w) => w.toJson()).toList()).toString();
    for (final v in WorkoutType.values) {
      expect(json, contains(v.name));
    }
    for (final v in WorkoutGoalType.values) {
      expect(json, contains('type: ${v.name}'));
    }
    for (final v in WorkoutAlertType.values) {
      expect(json, contains('type: ${v.name}'));
    }
    for (final v in WorkoutActivityType.values) {
      expect(json, contains('activityType: ${v.name}'));
    }
  });

  test('every random workout round-trips through fromJson', () {
    for (final workout in corpus) {
      final json = normalize(workout.toJson());
      final decoded = Workout.fromJson(json);
      expect(decoded.runtimeType, workout.runtimeType);
      expect(normalize(decoded.toJson()), json);
    }
  });

  test('the generator is deterministic', () {
    expect(
      normalize(
          generateRandomWorkouts(count: 20).map((w) => w.toJson()).toList()),
      normalize(corpus.take(20).map((w) => w.toJson()).toList()),
    );
  });
}
