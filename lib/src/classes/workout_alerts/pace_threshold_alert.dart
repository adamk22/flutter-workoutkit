import 'package:flutter_workoutkit/flutter_workoutkit.dart';
import 'package:flutter_workoutkit/src/utils/json.dart';

/// Alerts relative to a target running pace, e.g. 5:00 per km.
///
/// Sent to the Watch as a speed threshold alert; see [PaceRangeAlert] for
/// details.
class PaceThresholdAlert extends WorkoutAlert {
  /// The target pace (time per [paceUnit]).
  final Duration pace;

  /// The distance the pace is measured over.
  final PaceUnit paceUnit;

  /// The metric of the pace.
  final WorkoutAlertMetric metric;

  /// Creates a new pace threshold alert.
  PaceThresholdAlert({
    required this.pace,
    this.paceUnit = PaceUnit.perKilometer,
    this.metric = WorkoutAlertMetric.current,
  })  : assert(pace > Duration.zero, 'pace must be positive'),
        super(type: WorkoutAlertType.paceThreshold);

  /// The target speed in meters per second.
  double get thresholdMetersPerSecond => paceUnit.toMetersPerSecond(pace);

  @override
  String toDisplayString() {
    return '${formatPace(pace)} ${paceUnit.symbol}';
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'pace': durationToSeconds(pace),
      'paceUnit': paceUnit.name,
      'metric': metric.name,
      // Precomputed speed threshold consumed by the native side.
      'threshold': thresholdMetersPerSecond,
      'unitSpeed': UnitSpeed.metersPerSecond.name,
    };
  }

  /// Creates a new pace threshold alert from a JSON object.
  static PaceThresholdAlert fromJson(Map<String, dynamic> json) {
    return PaceThresholdAlert(
      pace: asSecondsDuration(json['pace']),
      paceUnit: PaceUnit.fromString(json['paceUnit'] as String),
      metric: WorkoutAlertMetric.fromString(json['metric'] as String),
    );
  }
}
