import 'package:flutter_workoutkit/flutter_workoutkit.dart';
import 'package:flutter_workoutkit/src/utils/json.dart';

/// Alerts relative to a target power, in watts.
///
/// [metric] `average` requires iOS 17.4+; earlier versions use `current`.
class PowerThresholdAlert extends WorkoutAlert {
  /// The threshold of the power.
  final double threshold;

  /// The metric of the power.
  final WorkoutAlertMetric metric;

  /// Creates a new power threshold alert.
  PowerThresholdAlert({
    required this.threshold,
    required this.metric,
  }) : super(type: WorkoutAlertType.powerThreshold);

  @override
  String toDisplayString() {
    return '$threshold watts';
  }

  @override
  Map<String, dynamic> toJson() {
    return {'type': type.name, 'threshold': threshold, 'metric': metric.name};
  }

  /// Returns a copy with the given fields replaced.
  PowerThresholdAlert copyWith(
          {double? threshold, WorkoutAlertMetric? metric}) =>
      PowerThresholdAlert(
        threshold: threshold ?? this.threshold,
        metric: metric ?? this.metric,
      );

  /// Creates a new power threshold alert from a JSON object.
  static PowerThresholdAlert fromJson(Map<String, dynamic> json) {
    return PowerThresholdAlert(
      threshold: asDouble(json['threshold']),
      metric: WorkoutAlertMetric.fromString(json['metric'] as String),
    );
  }
}
