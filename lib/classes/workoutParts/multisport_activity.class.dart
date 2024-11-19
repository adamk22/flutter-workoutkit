import 'package:flutter_workoutkit/workoutkit.dart';

class MultisportActivity {
  final MultisportActivityType type;
  final WorkoutLocationType? location;
  final WorkoutSwimmingLocationType? swimmingLocation;

  MultisportActivity({
    required this.type,
    this.location,
    this.swimmingLocation,
  }) : assert(
            (type == MultisportActivityType.swimming &&
                    swimmingLocation != null) ||
                (type != MultisportActivityType.swimming && location != null),
            'swimmingLocation required for swimming, location required for other activities');

  Map<String, dynamic> toJson() {
    return {
      'type': type.toString().split('.').last,
      'location': location?.toString().split('.').last,
      'swimmingLocation': swimmingLocation?.toString().split('.').last,
    };
  }
}
