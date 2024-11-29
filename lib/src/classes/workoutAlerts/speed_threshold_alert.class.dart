import 'package:flutter_workoutkit/flutter_workoutkit.dart';

/// Represents a speed threshold alert
class SpeedThresholdAlert extends WorkoutAlert {
  /// The threshold of the speed
  final double threshold;

  /// The unit of the speed
  final UnitSpeed unitSpeed;

  /// The metric of the speed
  final WorkoutAlertMetric metric;

  /// Creates a new speed threshold alert
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
      'type': type.toString().split('.').last,
      'threshold': threshold,
      'unitSpeed': unitSpeed.toString().split('.').last,
      'metric': metric.toString().split('.').last,
    };
  }

  /// Creates a new speed threshold alert from a JSON object
  static SpeedThresholdAlert fromJson(Map<String, dynamic> json) {
    return SpeedThresholdAlert(
      threshold: json['threshold'] as double,
      unitSpeed: UnitSpeed.fromString(json['unitSpeed'] as String),
      metric: WorkoutAlertMetric.fromString(json['metric'] as String),
    );
  }
}
