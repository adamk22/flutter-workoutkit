import 'package:flutter_workoutkit/flutter_workoutkit.dart';
import 'package:flutter_workoutkit/src/utils/json.dart';

/// Alerts when power leaves a range, in watts.
///
/// [metric] `average` requires iOS 17.4+; earlier versions use `current`.
class PowerRangeAlert extends WorkoutAlert {
  /// The lower bound of the power range.
  final double lowerBound;

  /// The upper bound of the power range.
  final double upperBound;

  /// The metric of the power.
  final WorkoutAlertMetric metric;

  /// Creates a new power range alert.
  PowerRangeAlert({
    required this.lowerBound,
    required this.upperBound,
    required this.metric,
  })  : assert(lowerBound <= upperBound, 'lowerBound must be <= upperBound'),
        super(type: WorkoutAlertType.powerRange);

  @override
  String toDisplayString() {
    return '$lowerBound - $upperBound watts';
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'lowerBound': lowerBound,
      'upperBound': upperBound,
      'metric': metric.name,
    };
  }

  /// Returns a copy with the given fields replaced.
  PowerRangeAlert copyWith({
    double? lowerBound,
    double? upperBound,
    WorkoutAlertMetric? metric,
  }) =>
      PowerRangeAlert(
        lowerBound: lowerBound ?? this.lowerBound,
        upperBound: upperBound ?? this.upperBound,
        metric: metric ?? this.metric,
      );

  /// Creates a new power range alert from a JSON object.
  static PowerRangeAlert fromJson(Map<String, dynamic> json) {
    return PowerRangeAlert(
      lowerBound: asDouble(json['lowerBound']),
      upperBound: asDouble(json['upperBound']),
      metric: WorkoutAlertMetric.fromString(json['metric'] as String),
    );
  }
}
