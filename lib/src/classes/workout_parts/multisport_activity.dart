import 'package:flutter_workoutkit/flutter_workoutkit.dart';
import 'package:flutter_workoutkit/src/utils/json_equality.dart';

/// One leg of a [SwimBikeRunWorkout].
class MultisportActivity with JsonValueEquality {
  /// The type of the activity.
  final MultisportActivityType type;

  /// The location of the activity. Required unless [type] is swimming.
  final WorkoutLocationType? location;

  /// The swimming location. Required if [type] is swimming.
  final WorkoutSwimmingLocationType? swimmingLocation;

  /// Creates a new multisport activity.
  MultisportActivity({
    required this.type,
    this.location,
    this.swimmingLocation,
  }) : assert(
            (type == MultisportActivityType.swimming &&
                    swimmingLocation != null) ||
                (type != MultisportActivityType.swimming && location != null),
            'swimmingLocation required for swimming, location required for other activities');

  /// Converts the multisport activity to a JSON object.
  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      if (location != null) 'location': location!.name,
      if (swimmingLocation != null) 'swimmingLocation': swimmingLocation!.name,
    };
  }

  /// Returns a copy with the given fields replaced.
  MultisportActivity copyWith({
    MultisportActivityType? type,
    WorkoutLocationType? location,
    WorkoutSwimmingLocationType? swimmingLocation,
  }) {
    return MultisportActivity(
      type: type ?? this.type,
      location: location ?? this.location,
      swimmingLocation: swimmingLocation ?? this.swimmingLocation,
    );
  }

  /// Creates a new multisport activity from a JSON object.
  static MultisportActivity fromJson(Map<String, dynamic> json) {
    return MultisportActivity(
      type: MultisportActivityType.fromString(json['type'] as String),
      location: json['location'] != null
          ? WorkoutLocationType.values.byName(json['location'] as String)
          : null,
      swimmingLocation: json['swimmingLocation'] != null
          ? WorkoutSwimmingLocationType.values
              .byName(json['swimmingLocation'] as String)
          : null,
    );
  }
}
