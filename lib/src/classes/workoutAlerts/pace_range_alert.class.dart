import 'package:flutter_workoutkit/workoutkit.dart';

/// Represents a pace range alert
class PaceRangeAlert extends WorkoutAlert {
  /// The lower bound of the pace range
  final double lowerBoundMinute;

  /// The lower bound of the pace range
  final double lowerBoundSecond;

  /// The upper bound of the pace range
  final double upperBoundMinute;

  /// The upper bound of the pace range
  final double upperBoundSecond;

  /// The unit of the pace
  final UnitSpeed unitSpeed;

  /// The metric of the pace
  final WorkoutAlertMetric metric;

  /// Creates a new pace range alert
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
