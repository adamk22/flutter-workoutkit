import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_workoutkit/flutter_workoutkit.dart';

void main() {
  test('every enum fromString accepts the name it serializes to', () {
    for (final v in WorkoutAlertType.values) {
      expect(WorkoutAlertType.fromString(v.name), v);
    }
    for (final v in WorkoutAlertMetric.values) {
      expect(WorkoutAlertMetric.fromString(v.name), v);
    }
    for (final v in UnitSpeed.values) {
      expect(UnitSpeed.fromString(v.name), v);
    }
    for (final v in PaceUnit.values) {
      expect(PaceUnit.fromString(v.name), v);
    }
    for (final v in WorkoutGoalType.values) {
      expect(WorkoutGoalType.fromString(v.name), v);
    }
    for (final v in WorkoutGoalUnit.values) {
      expect(WorkoutGoalUnit.fromString(v.name), v);
    }
    for (final v in GoalDistanceUnits.values) {
      expect(GoalDistanceUnits.fromString(v.name), v);
    }
    for (final v in GoalTimeUnits.values) {
      expect(GoalTimeUnits.fromString(v.name), v);
    }
    for (final v in WorkoutActivityType.values) {
      expect(WorkoutActivityType.fromString(v.name), v);
    }
    for (final v in WorkoutType.values) {
      expect(WorkoutType.fromString(v.name), v);
    }
    for (final v in MultisportActivityType.values) {
      expect(MultisportActivityType.fromString(v.name), v);
    }
  });

  test('UnitSpeed.fromString still accepts symbols', () {
    expect(UnitSpeed.fromString('m/s'), UnitSpeed.metersPerSecond);
    expect(UnitSpeed.fromString('kph'), UnitSpeed.kilometersPerHour);
    expect(() => UnitSpeed.fromString('furlongs'), throwsArgumentError);
  });

  test('location fromString is lenient', () {
    expect(
        WorkoutLocationType.fromString('Outdoor'), WorkoutLocationType.outdoor);
    expect(WorkoutLocationType.fromString(null), WorkoutLocationType.unknown);
    expect(WorkoutSwimmingLocationType.fromString('openWater'),
        WorkoutSwimmingLocationType.openWater);
  });

  test('WorkoutGoalUnit categories', () {
    expect(WorkoutGoalUnit.kilometers.isDistance, isTrue);
    expect(WorkoutGoalUnit.minutes.isTime, isTrue);
    expect(WorkoutGoalUnit.kilocalories.isEnergy, isTrue);
    expect(WorkoutGoalUnit.open.isDistance || WorkoutGoalUnit.open.isTime,
        isFalse);
  });
}
