import 'package:flutter_workoutkit/flutter_workoutkit.dart';
import 'package:flutter_workoutkit/src/utils/json.dart';

/// Alerts relative to a target speed. For running, prefer
/// [PaceThresholdAlert].
class SpeedThresholdAlert extends WorkoutAlert {
  /// The threshold of the speed.
  final double threshold;

  /// The unit of the speed.
  final UnitSpeed unitSpeed;

  /// The metric of the speed.
  final WorkoutAlertMetric metric;

  /// Creates a new speed threshold alert.
  SpeedThresholdAlert({
    required this.threshold,
    required this.unitSpeed,
    required this.metric,
  }) : super(type: WorkoutAlertType.speedThreshold);

  @override
  String toDisplayString() {
    return '$threshold ${unitSpeed.symbol}';
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'threshold': threshold,
      'unitSpeed': unitSpeed.name,
      'metric': metric.name,
    };
  }

  /// Returns a copy with the given fields replaced.
  SpeedThresholdAlert copyWith({
    double? threshold,
    UnitSpeed? unitSpeed,
    WorkoutAlertMetric? metric,
  }) =>
      SpeedThresholdAlert(
        threshold: threshold ?? this.threshold,
        unitSpeed: unitSpeed ?? this.unitSpeed,
        metric: metric ?? this.metric,
      );

  /// Creates a new speed threshold alert from a JSON object.
  static SpeedThresholdAlert fromJson(Map<String, dynamic> json) {
    return SpeedThresholdAlert(
      threshold: asDouble(json['threshold']),
      unitSpeed: UnitSpeed.fromString(json['unitSpeed'] as String),
      metric: WorkoutAlertMetric.fromString(json['metric'] as String),
    );
  }
}
