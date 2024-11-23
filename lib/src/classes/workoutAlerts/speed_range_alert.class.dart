import 'package:flutter_workoutkit/workoutkit.dart';

/// Represents a speed range alert
class SpeedRangeAlert extends WorkoutAlert {
  /// The lower bound of the speed range
  final double lowerBound;

  /// The upper bound of the speed range
  final double upperBound;

  /// The unit of the speed
  final UnitSpeed unitSpeed;

  /// The metric of the speed
  final WorkoutAlertMetric metric;

  /// Creates a new speed range alert
  SpeedRangeAlert({
    required this.lowerBound,
    required this.upperBound,
    required this.unitSpeed,
    required this.metric,
  }) : super(type: WorkoutAlertType.speedRange);

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type.toString().split('.').last,
      'lowerBound': lowerBound,
      'upperBound': upperBound,
      'unitSpeed': unitSpeed.toString().split('.').last,
      'metric': metric.toString().split('.').last,
    };
  }

  /// Creates a new speed range alert from a JSON object
  static SpeedRangeAlert fromJson(Map<String, dynamic> json) {
    return SpeedRangeAlert(
      lowerBound: json['lowerBound'] as double,
      upperBound: json['upperBound'] as double,
      unitSpeed: UnitSpeed.fromString(json['unitSpeed'] as String),
      metric: WorkoutAlertMetric.fromString(json['metric'] as String),
    );
  }
}
