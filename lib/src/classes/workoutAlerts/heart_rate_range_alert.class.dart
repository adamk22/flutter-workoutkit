import 'package:flutter_workoutkit/workoutkit.dart';

class HeartRateRangeAlert extends WorkoutAlert {
  final double lowerBound;
  final double upperBound;

  HeartRateRangeAlert({required this.lowerBound, required this.upperBound})
      : super(type: WorkoutAlertType.heartRateRange);

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type.toString().split('.').last,
      'lowerBound': lowerBound,
      'upperBound': upperBound,
    };
  }
}
