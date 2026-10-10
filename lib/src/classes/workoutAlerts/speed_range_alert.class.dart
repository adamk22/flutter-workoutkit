import 'package:flutter_workoutkit/flutter_workoutkit.dart';
import 'package:flutter_workoutkit/src/utils/json.dart';

/// Alerts when speed leaves a range. For running, prefer [PaceRangeAlert].
class SpeedRangeAlert extends WorkoutAlert {
  /// The lower bound of the speed range.
  final double lowerBound;

  /// The upper bound of the speed range.
  final double upperBound;

  /// The unit of the speed.
  final UnitSpeed unitSpeed;

  /// The metric of the speed.
  final WorkoutAlertMetric metric;

  /// Creates a new speed range alert.
  SpeedRangeAlert({
    required this.lowerBound,
    required this.upperBound,
    required this.unitSpeed,
    required this.metric,
  })  : assert(lowerBound <= upperBound, 'lowerBound must be <= upperBound'),
        super(type: WorkoutAlertType.speedRange);

  @override
  String toDisplayString() {
    return '$lowerBound - $upperBound ${unitSpeed.symbol}';
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'lowerBound': lowerBound,
      'upperBound': upperBound,
      'unitSpeed': unitSpeed.name,
      'metric': metric.name,
    };
  }

  /// Creates a new speed range alert from a JSON object.
  static SpeedRangeAlert fromJson(Map<String, dynamic> json) {
    return SpeedRangeAlert(
      lowerBound: asDouble(json['lowerBound']),
      upperBound: asDouble(json['upperBound']),
      unitSpeed: UnitSpeed.fromString(json['unitSpeed'] as String),
      metric: WorkoutAlertMetric.fromString(json['metric'] as String),
    );
  }
}
