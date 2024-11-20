import 'package:flutter_workoutkit/workoutkit.dart';

class SpeedThresholdAlert extends WorkoutAlert {
  final double threshold;
  final UnitSpeed unitSpeed;
  final WorkoutAlertMetric metric;

  SpeedThresholdAlert({
    required this.threshold,
    required this.unitSpeed,
    required this.metric,
  }) : super(type: WorkoutAlertType.speedThreshold);

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type.toString().split('.').last,
      'threshold': threshold,
      'unitSpeed': unitSpeed.toString().split('.').last,
      'metric': metric.toString().split('.').last,
    };
  }
}
