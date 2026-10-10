import 'package:flutter_workoutkit/flutter_workoutkit.dart';
import 'package:flutter_workoutkit/src/utils/json.dart';

/// Alerts when running pace leaves a range, e.g. between 5:00 and 5:30 per km.
///
/// WorkoutKit has no dedicated pace alert: this is sent to the Watch as a
/// speed range alert. The Workout app shows it as pace or speed depending on
/// the user's settings. Plans read back from WorkoutKit (scheduled or
/// imported) therefore come back as a [SpeedRangeAlert] in m/s.
class PaceRangeAlert extends WorkoutAlert {
  /// The fastest acceptable pace (shortest time per [paceUnit]).
  final Duration fastestPace;

  /// The slowest acceptable pace (longest time per [paceUnit]).
  final Duration slowestPace;

  /// The distance the paces are measured over.
  final PaceUnit paceUnit;

  /// The metric of the pace.
  final WorkoutAlertMetric metric;

  /// Creates a new pace range alert.
  PaceRangeAlert({
    required this.fastestPace,
    required this.slowestPace,
    this.paceUnit = PaceUnit.perKilometer,
    this.metric = WorkoutAlertMetric.current,
  })  : assert(fastestPace > Duration.zero, 'fastestPace must be positive'),
        assert(fastestPace <= slowestPace,
            'fastestPace must be shorter than or equal to slowestPace'),
        super(type: WorkoutAlertType.paceRange);

  /// The lower speed bound (from [slowestPace]) in meters per second.
  double get lowerBoundMetersPerSecond =>
      paceUnit.toMetersPerSecond(slowestPace);

  /// The upper speed bound (from [fastestPace]) in meters per second.
  double get upperBoundMetersPerSecond =>
      paceUnit.toMetersPerSecond(fastestPace);

  @override
  String toDisplayString() {
    return '${formatPace(fastestPace)} - ${formatPace(slowestPace)} '
        '${paceUnit.symbol}';
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'fastestPace': durationToSeconds(fastestPace),
      'slowestPace': durationToSeconds(slowestPace),
      'paceUnit': paceUnit.name,
      'metric': metric.name,
      // Precomputed speed bounds consumed by the native side.
      'lowerBound': lowerBoundMetersPerSecond,
      'upperBound': upperBoundMetersPerSecond,
      'unitSpeed': UnitSpeed.metersPerSecond.name,
    };
  }

  /// Returns a copy with the given fields replaced.
  PaceRangeAlert copyWith({
    Duration? fastestPace,
    Duration? slowestPace,
    PaceUnit? paceUnit,
    WorkoutAlertMetric? metric,
  }) =>
      PaceRangeAlert(
        fastestPace: fastestPace ?? this.fastestPace,
        slowestPace: slowestPace ?? this.slowestPace,
        paceUnit: paceUnit ?? this.paceUnit,
        metric: metric ?? this.metric,
      );

  /// Creates a new pace range alert from a JSON object.
  static PaceRangeAlert fromJson(Map<String, dynamic> json) {
    return PaceRangeAlert(
      fastestPace: asSecondsDuration(json['fastestPace']),
      slowestPace: asSecondsDuration(json['slowestPace']),
      paceUnit: PaceUnit.fromString(json['paceUnit'] as String),
      metric: WorkoutAlertMetric.fromString(json['metric'] as String),
    );
  }
}

/// Formats a pace as `m:ss`.
String formatPace(Duration pace) {
  final seconds = pace.inSeconds % 60;
  return '${pace.inMinutes}:${seconds.toString().padLeft(2, '0')}';
}
