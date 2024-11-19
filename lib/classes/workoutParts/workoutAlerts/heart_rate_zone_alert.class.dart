import 'package:flutter_workoutkit/workoutkit.dart';

class HeartRateZoneAlert extends WorkoutAlert {
  final int zone;

  HeartRateZoneAlert({required this.zone})
      : super(type: WorkoutAlertType.heartRateZone);

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type.toString().split('.').last,
      'zone': zone,
    };
  }
}
