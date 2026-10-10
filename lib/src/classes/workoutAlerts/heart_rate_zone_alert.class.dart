import 'package:flutter_workoutkit/flutter_workoutkit.dart';

/// Alerts when the user leaves a heart rate zone (1–5) as configured in the
/// Workout app.
class HeartRateZoneAlert extends WorkoutAlert {
  /// The heart rate zone, 1 through 5.
  final int zone;

  /// Creates a new heart rate zone alert.
  HeartRateZoneAlert({required this.zone})
      : assert(zone >= 1 && zone <= 5, 'zone must be between 1 and 5'),
        super(type: WorkoutAlertType.heartRateZone);

  @override
  String toDisplayString() {
    return 'HR Zone $zone';
  }

  @override
  Map<String, dynamic> toJson() {
    return {'type': type.name, 'zone': zone};
  }

  /// Creates a new heart rate zone alert from a JSON object.
  static HeartRateZoneAlert fromJson(Map<String, dynamic> json) {
    return HeartRateZoneAlert(zone: (json['zone'] as num).toInt());
  }
}
