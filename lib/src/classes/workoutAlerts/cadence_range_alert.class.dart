import 'package:flutter_workoutkit/flutter_workoutkit.dart';
import 'package:flutter_workoutkit/src/utils/json.dart';

/// Alerts when cadence leaves a range, in steps or revolutions per minute.
class CadenceRangeAlert extends WorkoutAlert {
  /// The lower bound of the cadence range.
  final double lowerBound;

  /// The upper bound of the cadence range.
  final double upperBound;

  /// Creates a new cadence range alert.
  CadenceRangeAlert({required this.lowerBound, required this.upperBound})
      : assert(lowerBound <= upperBound, 'lowerBound must be <= upperBound'),
        super(type: WorkoutAlertType.cadenceRange);

  @override
  String toDisplayString() {
    return 'Cadence Range: $lowerBound - $upperBound rpm';
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'lowerBound': lowerBound,
      'upperBound': upperBound,
    };
  }

  /// Creates a new cadence range alert from a JSON object.
  static CadenceRangeAlert fromJson(Map<String, dynamic> json) {
    return CadenceRangeAlert(
      lowerBound: asDouble(json['lowerBound']),
      upperBound: asDouble(json['upperBound']),
    );
  }
}
