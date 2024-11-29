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
  String toDisplayString() {
    return '$lowerBound - $upperBound bpm';
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type.toString().split('.').last,
      'lowerBound': lowerBound,
      'upperBound': upperBound,
    };
  }

  /// Creates a new heart rate range alert from a JSON object
  static HeartRateRangeAlert fromJson(Map<String, dynamic> json) {
    return HeartRateRangeAlert(
      lowerBound: json['lowerBound'] as double,
      upperBound: json['upperBound'] as double,
    );
  }
}
