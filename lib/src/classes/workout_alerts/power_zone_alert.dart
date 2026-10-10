import 'package:flutter_workoutkit/flutter_workoutkit.dart';

/// Alerts when the user leaves a power zone as configured in the Workout app.
class PowerZoneAlert extends WorkoutAlert {
  /// The power zone, starting at 1.
  final int zone;

  /// Kept for backwards compatibility. WorkoutKit power zone alerts always use
  /// the current value, so this is ignored on the native side.
  final WorkoutAlertMetric metric;

  /// Creates a new power zone alert.
  PowerZoneAlert({
    required this.zone,
    this.metric = WorkoutAlertMetric.current,
  })  : assert(zone >= 1, 'zone must be >= 1'),
        super(type: WorkoutAlertType.powerZone);

  @override
  String toDisplayString() {
    return 'Power Zone $zone';
  }

  @override
  Map<String, dynamic> toJson() {
    return {'type': type.name, 'zone': zone, 'metric': metric.name};
  }

  /// Creates a new power zone alert from a JSON object.
  static PowerZoneAlert fromJson(Map<String, dynamic> json) {
    return PowerZoneAlert(
      zone: (json['zone'] as num).toInt(),
      metric: json['metric'] != null
          ? WorkoutAlertMetric.fromString(json['metric'] as String)
          : WorkoutAlertMetric.current,
    );
  }
}
