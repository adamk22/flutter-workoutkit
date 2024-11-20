import 'package:flutter_workoutkit/workoutkit.dart';

/// Represents a cadence threshold alert
class CadenceThresholdAlert extends WorkoutAlert {
  /// The threshold of the cadence
  final double threshold;

  /// Creates a new cadence threshold alert
  CadenceThresholdAlert({required this.threshold})
      : super(type: WorkoutAlertType.cadenceThreshold);

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type.toString().split('.').last,
      'threshold': threshold,
    };
  }
}
