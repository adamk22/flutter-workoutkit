import 'package:flutter_workoutkit/workoutkit.dart';

/// Represents a heart rate zone alert
class HeartRateZoneAlert extends WorkoutAlert {
  /// The zone of the heart rate
  /// min zone is 1, max zone is 5
  final int zone;

  /// Creates a new heart rate zone alert
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
