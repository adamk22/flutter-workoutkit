import 'package:flutter_workoutkit/workoutkit.dart';

class PaceThresholdAlert extends WorkoutAlert {
  final double thresholdMinute;
  final double thresholdSecond;
  final UnitSpeed unitSpeed;
  final WorkoutAlertMetric metric;

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
