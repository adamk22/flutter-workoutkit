import 'package:flutter_workoutkit/workoutkit.dart';

class CadenceThresholdAlert extends WorkoutAlert {
  final double threshold;

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
