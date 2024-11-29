import 'package:flutter_workoutkit/flutter_workoutkit.dart';

/// Represents a multisport activity
class MultisportActivity {
  /// The type of the activity
  final MultisportActivityType type;

  /// The location of the activity
  /// location is required if the activity type is not swimming
  final WorkoutLocationType? location;

  /// The swimming location of the activity (optional)
  /// swimmingLocation is required if the activity type is swimming
  final WorkoutSwimmingLocationType? swimmingLocation;

  /// Creates a new multisport activity
  MultisportActivity({
    required this.type,
    this.location,
    this.swimmingLocation,
  }) : assert(
            (type == MultisportActivityType.swimming &&
                    swimmingLocation != null) ||
                (type != MultisportActivityType.swimming && location != null),
            'swimmingLocation required for swimming, location required for other activities');

  /// Converts the multisport activity to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'type': type.toString().split('.').last,
      'location': location?.toString().split('.').last,
      'swimmingLocation': swimmingLocation?.toString().split('.').last,
    };
  }

  /// Creates a new multisport activity from a JSON object
  static MultisportActivity fromJson(Map<String, dynamic> json) {
    return MultisportActivity(
      type: MultisportActivityType.values
          .firstWhere((e) => e.toString().split('.').last == json['type']),
      location: json['location'] != null
          ? WorkoutLocationType.values.firstWhere(
              (e) => e.toString().split('.').last == json['location'])
          : null,
      swimmingLocation: json['swimmingLocation'] != null
          ? WorkoutSwimmingLocationType.values.firstWhere(
              (e) => e.toString().split('.').last == json['swimmingLocation'])
          : null,
    );
  }
}
