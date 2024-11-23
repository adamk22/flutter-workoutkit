import 'package:flutter_workoutkit/workoutkit.dart';

/// Represents a cadence range alert
class CadenceRangeAlert extends WorkoutAlert {
  /// The lower bound of the cadence range
  final double lowerBound;

  /// The upper bound of the cadence range
  final double upperBound;

  /// Creates a new cadence range alert
  CadenceRangeAlert({required this.lowerBound, required this.upperBound})
      : super(type: WorkoutAlertType.cadenceRange);

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type.toString().split('.').last,
    };
  }

  /// Creates a new cadence range alert from a JSON object
  static CadenceRangeAlert fromJson(Map<String, dynamic> json) {
    return CadenceRangeAlert(
      lowerBound: json['lowerBound'] as double,
      upperBound: json['upperBound'] as double,
    );
  }
}
