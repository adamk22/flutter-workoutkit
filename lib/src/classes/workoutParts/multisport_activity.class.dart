import 'package:flutter_workoutkit/workoutkit.dart';

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
}
