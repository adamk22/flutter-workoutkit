import 'package:flutter_workoutkit/workoutkit.dart';

class SpeedRangeAlert extends WorkoutAlert {
  final double lowerBound;
  final double upperBound;
  final UnitSpeed unitSpeed;
  final WorkoutAlertMetric metric;

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
}
