import 'package:flutter_workoutkit/workoutkit.dart';

/// Represents a cadence threshold alert
class CadenceThresholdAlert extends WorkoutAlert {
  /// The threshold of the cadence
  final double threshold;

  /// Creates a new cadence threshold alert
  CadenceThresholdAlert({required this.threshold})
      : super(type: WorkoutAlertType.cadenceThreshold);

  @override
  String toDisplayString() {
    return '$threshold rpm';
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type.toString().split('.').last,
      'threshold': threshold,
    };
  }

  /// Creates a new cadence threshold alert from a JSON object
  static CadenceThresholdAlert fromJson(Map<String, dynamic> json) {
    return CadenceThresholdAlert(threshold: json['threshold'] as double);
  }
}
