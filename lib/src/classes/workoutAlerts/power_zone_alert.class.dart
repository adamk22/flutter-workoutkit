import 'package:flutter_workoutkit/flutter_workoutkit.dart';

/// Represents a power zone alert
class PowerZoneAlert extends WorkoutAlert {
  /// The zone of the power
  /// min zone is 1, max zone is 5
  final int zone;

  /// The metric of the power
  final WorkoutAlertMetric metric;

  /// Creates a new power zone alert
  PowerZoneAlert({
    required this.zone,
    required this.metric,
  }) : super(type: WorkoutAlertType.powerZone);

  @override
  String toDisplayString() {
    return 'Power Zone $zone';
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type.toString().split('.').last,
      'zone': zone,
      'metric': metric.toString().split('.').last,
    };
  }

  /// Creates a new power zone alert from a JSON object
  static PowerZoneAlert fromJson(Map<String, dynamic> json) {
    return PowerZoneAlert(
      zone: json['zone'] as int,
      metric: WorkoutAlertMetric.fromString(json['metric'] as String),
    );
  }
}
