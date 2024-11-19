import 'package:flutter_workoutkit/workoutkit.dart';

class PowerZoneAlert extends WorkoutAlert {
  final int zone;
  final WorkoutAlertMetric metric;

  PowerZoneAlert({
    required this.zone,
    required this.metric,
  }) : super(type: WorkoutAlertType.powerZone);

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type.toString().split('.').last,
      'zone': zone,
      'metric': metric.toString().split('.').last,
    };
  }
}
