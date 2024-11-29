import 'package:flutter_workoutkit/flutter_workoutkit.dart';

/// Represents a power range alert
class PowerRangeAlert extends WorkoutAlert {
  /// The lower bound of the power range
  final double lowerBound;

  /// The upper bound of the power range
  final double upperBound;

  /// The metric of the power
  final WorkoutAlertMetric metric;

  /// Creates a new power range alert
  PowerRangeAlert({
    required this.lowerBound,
    required this.upperBound,
    required this.metric,
  }) : super(type: WorkoutAlertType.powerRange);

  @override
  String toDisplayString() {
    return '$lowerBound - $upperBound watts';
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type.toString().split('.').last,
      'lowerBound': lowerBound,
      'upperBound': upperBound,
      'metric': metric.toString().split('.').last,
    };
  }

  /// Creates a new power range alert from a JSON object
  static PowerRangeAlert fromJson(Map<String, dynamic> json) {
    return PowerRangeAlert(
      lowerBound: json['lowerBound'] as double,
      upperBound: json['upperBound'] as double,
      metric: WorkoutAlertMetric.fromString(json['metric'] as String),
    );
  }
}
