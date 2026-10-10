import 'package:flutter_workoutkit/flutter_workoutkit.dart';
import 'package:flutter_workoutkit/src/utils/json.dart';

/// Alerts relative to a target cadence, in steps or revolutions per minute.
class CadenceThresholdAlert extends WorkoutAlert {
  /// The threshold of the cadence.
  final double threshold;

  /// Creates a new cadence threshold alert.
  CadenceThresholdAlert({required this.threshold})
      : super(type: WorkoutAlertType.cadenceThreshold);

  @override
  String toDisplayString() {
    return '$threshold rpm';
  }

  @override
  Map<String, dynamic> toJson() {
    return {'type': type.name, 'threshold': threshold};
  }

  /// Creates a new cadence threshold alert from a JSON object.
  static CadenceThresholdAlert fromJson(Map<String, dynamic> json) {
    return CadenceThresholdAlert(threshold: asDouble(json['threshold']));
  }
}
