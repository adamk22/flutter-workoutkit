import 'package:flutter_workoutkit/workoutkit.dart';

class CadenceRangeAlert extends WorkoutAlert {
  final double lowerBound;
  final double upperBound;

  CadenceRangeAlert({required this.lowerBound, required this.upperBound})
      : super(type: WorkoutAlertType.cadenceRange);

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type.toString().split('.').last,
    };
  }
}
