import 'package:flutter_workoutkit/workoutkit.dart';

class PaceRangeAlert extends WorkoutAlert {
  final double lowerBoundMinute;
  final double lowerBoundSecond;
  final double upperBoundMinute;
  final double upperBoundSecond;
  final UnitSpeed unitSpeed;
  final WorkoutAlertMetric metric;

  PaceRangeAlert({
    required this.lowerBoundMinute,
    required this.lowerBoundSecond,
    required this.upperBoundMinute,
    required this.upperBoundSecond,
    required this.unitSpeed,
    required this.metric,
  }) : super(type: WorkoutAlertType.paceRange);

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type.toString().split('.').last,
      'lowerBoundMinute': lowerBoundMinute,
      'lowerBoundSecond': lowerBoundSecond,
      'upperBoundMinute': upperBoundMinute,
      'upperBoundSecond': upperBoundSecond,
      'unitSpeed': unitSpeed.toString().split('.').last,
      'metric': metric.toString().split('.').last,
    };
  }
}
