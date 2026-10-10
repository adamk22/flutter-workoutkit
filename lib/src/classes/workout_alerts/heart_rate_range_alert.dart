import 'package:flutter_workoutkit/flutter_workoutkit.dart';
import 'package:flutter_workoutkit/src/utils/json.dart';

/// Alerts when heart rate leaves a range, in beats per minute.
class HeartRateRangeAlert extends WorkoutAlert {
  /// The lower bound of the heart rate range.
  final double lowerBound;

  /// The upper bound of the heart rate range.
  final double upperBound;

  /// Creates a new heart rate range alert.
  HeartRateRangeAlert({required this.lowerBound, required this.upperBound})
      : assert(lowerBound <= upperBound, 'lowerBound must be <= upperBound'),
        super(type: WorkoutAlertType.heartRateRange);

  @override
  String toDisplayString() {
    return '${lowerBound.toInt()} - ${upperBound.toInt()} bpm';
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'lowerBound': lowerBound,
      'upperBound': upperBound,
    };
  }

  /// Returns a copy with the given fields replaced.
  HeartRateRangeAlert copyWith({double? lowerBound, double? upperBound}) =>
      HeartRateRangeAlert(
        lowerBound: lowerBound ?? this.lowerBound,
        upperBound: upperBound ?? this.upperBound,
      );

  /// Creates a new heart rate range alert from a JSON object.
  static HeartRateRangeAlert fromJson(Map<String, dynamic> json) {
    return HeartRateRangeAlert(
      lowerBound: asDouble(json['lowerBound']),
      upperBound: asDouble(json['upperBound']),
    );
  }
}
