import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_workoutkit/flutter_workoutkit.dart';
import 'package:flutter_workoutkit/src/classes/scheduled_workout.class.dart'
    show dateFromComponents, dateToComponents;

void main() {
  group('date components', () {
    test('drop seconds and keep local wall-clock time', () {
      expect(dateToComponents(DateTime(2026, 6, 15, 14, 30, 59, 999)),
          {'year': 2026, 'month': 6, 'day': 15, 'hour': 14, 'minute': 30});
    });

    test('UTC dates are converted to local time first', () {
      final utc = DateTime.utc(2026, 10, 10, 6, 15);
      final local = utc.toLocal();
      expect(dateToComponents(utc)['hour'], local.hour);
      expect(dateToComponents(utc)['day'], local.day);
    });

    test('round-trip at minute precision', () {
      final date = DateTime(2026, 12, 31, 23, 59);
      expect(dateFromComponents(dateToComponents(date)), date);
    });

    test('missing components default sensibly', () {
      expect(dateFromComponents({'year': 2026}), DateTime(2026));
    });
  });

  test('ScheduledWorkout serializes and parses', () {
    final scheduled = ScheduledWorkout(
      workout: Workout.fromJson({
        ...samplePacerMinutesWorkout.toJson(),
        'id': 'ABC',
      }),
      date: DateTime(2026, 10, 12, 7),
      complete: true,
    );
    final parsed = ScheduledWorkout.fromJson(scheduled.toJson());
    expect(parsed.id, 'ABC');
    expect(parsed.date, scheduled.date);
    expect(parsed.complete, isTrue);
    expect(parsed.workout.toJson(), scheduled.workout.toJson());
  });

  test('WorkoutValidationResult parses native payloads', () {
    final result = WorkoutValidationResult.fromJson({
      'isValid': false,
      'issues': <Object?>['a', 'b'],
    });
    expect(result.issues, ['a', 'b']);
    expect(result.toString(), contains('a; b'));
  });
}
