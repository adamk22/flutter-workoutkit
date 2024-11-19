import 'package:flutter_workoutkit/workoutkit.dart';

class PowerRangeAlert extends WorkoutAlert {
  final double lowerBound;
  final double upperBound;
  final WorkoutAlertMetric metric;

  PowerRangeAlert({
    required this.lowerBound,
    required this.upperBound,
    required this.metric,
  }) : super(type: WorkoutAlertType.powerRange);

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type.toString().split('.').last,
      'lowerBound': lowerBound,
      'upperBound': upperBound,
      'metric': metric.toString().split('.').last,
    };
  }
}
