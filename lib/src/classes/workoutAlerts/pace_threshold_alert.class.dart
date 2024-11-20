import 'package:flutter_workoutkit/workoutkit.dart';

/// Represents a pace threshold alert
class PaceThresholdAlert extends WorkoutAlert {
  /// The threshold of the pace
  final double thresholdMinute;

  /// The threshold of the pace
  final double thresholdSecond;

  /// The unit of the pace
  final UnitSpeed unitSpeed;

  /// The metric of the pace
  final WorkoutAlertMetric metric;

  /// Creates a new pace threshold alert
  PaceThresholdAlert({
    required this.thresholdMinute,
    required this.thresholdSecond,
    required this.unitSpeed,
    required this.metric,
  }) : super(type: WorkoutAlertType.paceRange);

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type.toString().split('.').last,
      'thresholdMinute': thresholdMinute,
      'thresholdSecond': thresholdSecond,
      'unitSpeed': unitSpeed.toString().split('.').last,
      'metric': metric.toString().split('.').last,
    };
  }
}
