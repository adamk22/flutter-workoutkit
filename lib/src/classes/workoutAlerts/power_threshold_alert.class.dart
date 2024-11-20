import 'package:flutter_workoutkit/workoutkit.dart';

class PowerThresholdAlert extends WorkoutAlert {
  final double threshold;
  final WorkoutAlertMetric metric;

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
