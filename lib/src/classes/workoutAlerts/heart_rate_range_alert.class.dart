import 'package:flutter_workoutkit/workoutkit.dart';

/// Represents a heart rate range alert
class HeartRateRangeAlert extends WorkoutAlert {
  /// The lower bound of the heart rate range
  final double lowerBound;

  /// The upper bound of the heart rate range
  final double upperBound;

  /// Creates a new heart rate range alert
  HeartRateRangeAlert({required this.lowerBound, required this.upperBound})
      : super(type: WorkoutAlertType.heartRateRange);

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type.toString().split('.').last,
      'lowerBound': lowerBound,
      'upperBound': upperBound,
    };
  }
}
