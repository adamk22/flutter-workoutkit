import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_workoutkit/flutter_workoutkit.dart';

void main() {
  group('PaceRangeAlert', () {
    test('converts paces to speed bounds (slowest pace = lower speed)', () {
      final alert = PaceRangeAlert(
        fastestPace: const Duration(minutes: 4),
        slowestPace: const Duration(minutes: 5),
      );
      expect(alert.lowerBoundMetersPerSecond, closeTo(1000 / 300, 1e-12));
      expect(alert.upperBoundMetersPerSecond, closeTo(1000 / 240, 1e-12));
      final json = alert.toJson();
      expect(json['type'], 'paceRange');
      expect(json['unitSpeed'], 'metersPerSecond');
      expect(
          json['lowerBound'] as double, lessThan(json['upperBound'] as double));
    });

    test('supports miles', () {
      final alert = PaceRangeAlert(
        fastestPace: const Duration(minutes: 8),
        slowestPace: const Duration(minutes: 9),
        paceUnit: PaceUnit.perMile,
      );
      expect(alert.upperBoundMetersPerSecond, closeTo(1609.344 / 480, 1e-12));
    });

    test('rejects a fastest pace slower than the slowest pace', () {
      expect(
        () => PaceRangeAlert(
          fastestPace: const Duration(minutes: 6),
          slowestPace: const Duration(minutes: 5),
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test('toDisplayString formats m:ss', () {
      final alert = PaceRangeAlert(
        fastestPace: const Duration(minutes: 5, seconds: 5),
        slowestPace: const Duration(minutes: 5, seconds: 30),
      );
      expect(alert.toDisplayString(), '5:05 - 5:30 /km');
    });
  });

  group('PaceThresholdAlert', () {
    test('serializes as its own type with a speed threshold', () {
      final alert = PaceThresholdAlert(pace: const Duration(minutes: 5));
      final json = alert.toJson();
      expect(json['type'], 'paceThreshold');
      expect(json['threshold'], closeTo(1000 / 300, 1e-12));
      expect(WorkoutAlert.fromJson(json), isA<PaceThresholdAlert>());
    });

    test('supports fractional seconds', () {
      final alert =
          PaceThresholdAlert(pace: const Duration(milliseconds: 300500));
      expect(alert.toJson()['pace'], 300.5);
      expect(
        (WorkoutAlert.fromJson(alert.toJson()) as PaceThresholdAlert).pace,
        const Duration(milliseconds: 300500),
      );
    });
  });
}
