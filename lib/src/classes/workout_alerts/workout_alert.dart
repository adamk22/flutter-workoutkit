import 'package:flutter_workoutkit/flutter_workoutkit.dart';
import 'package:flutter_workoutkit/src/utils/json_equality.dart';

/// Base class for alerts attached to a [WorkoutStep] or [IntervalStep].
///
/// Use one of the concrete subclasses, e.g. [HeartRateZoneAlert] or
/// [SpeedRangeAlert].
abstract class WorkoutAlert with JsonValueEquality {
  /// The type of the workout alert.
  final WorkoutAlertType type;

  /// Creates a new workout alert.
  WorkoutAlert({required this.type});

  /// Returns a string representation of the workout alert.
  String toDisplayString() {
    return type.label;
  }

  /// Converts the workout alert to a JSON object.
  @override
  Map<String, dynamic> toJson() {
    return {'type': type.name};
  }

  /// Creates the concrete alert subclass described by [json]'s `type`.
  factory WorkoutAlert.fromJson(Map<String, dynamic> json) {
    switch (WorkoutAlertType.fromString(json['type'] as String)) {
      case WorkoutAlertType.cadenceRange:
        return CadenceRangeAlert.fromJson(json);
      case WorkoutAlertType.cadenceThreshold:
        return CadenceThresholdAlert.fromJson(json);
      case WorkoutAlertType.heartRateRange:
        return HeartRateRangeAlert.fromJson(json);
      case WorkoutAlertType.heartRateZone:
        return HeartRateZoneAlert.fromJson(json);
      case WorkoutAlertType.powerRange:
        return PowerRangeAlert.fromJson(json);
      case WorkoutAlertType.powerThreshold:
        return PowerThresholdAlert.fromJson(json);
      case WorkoutAlertType.powerZone:
        return PowerZoneAlert.fromJson(json);
      case WorkoutAlertType.speedRange:
        return SpeedRangeAlert.fromJson(json);
      case WorkoutAlertType.speedThreshold:
        return SpeedThresholdAlert.fromJson(json);
      case WorkoutAlertType.paceRange:
        return PaceRangeAlert.fromJson(json);
      case WorkoutAlertType.paceThreshold:
        return PaceThresholdAlert.fromJson(json);
    }
  }
}
