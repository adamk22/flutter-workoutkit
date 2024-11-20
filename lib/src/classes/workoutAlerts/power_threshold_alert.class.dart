import 'package:flutter_workoutkit/workoutkit.dart';

/// Represents a power threshold alert
class PowerThresholdAlert extends WorkoutAlert {
  /// The threshold of the power
  final double threshold;

  /// The metric of the power
  final WorkoutAlertMetric metric;

  /// Creates a new power threshold alert
  PowerThresholdAlert({
    required this.threshold,
    required this.metric,
  }) : super(type: WorkoutAlertType.powerThreshold);

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type.toString().split('.').last,
      'threshold': threshold,
      'metric': metric.toString().split('.').last,
    };
  }
}
