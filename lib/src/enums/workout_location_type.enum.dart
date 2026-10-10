/// Where a non-swimming workout takes place.
enum WorkoutLocationType {
  /// Unknown; the user picks the location when starting the workout.
  unknown(label: 'Unknown'),

  /// Indoors.
  indoor(label: 'Indoor'),

  /// Outdoors.
  outdoor(label: 'Outdoor');

  /// Human readable label.
  final String label;

  const WorkoutLocationType({required this.label});

  /// Whether this is [indoor].
  bool get isIndoor => this == WorkoutLocationType.indoor;

  /// Whether this is [outdoor].
  bool get isOutdoor => this == WorkoutLocationType.outdoor;

  /// Whether this is [unknown].
  bool get isUnknown => this == WorkoutLocationType.unknown;

  /// Parses a location case-insensitively, defaulting to [unknown].
  factory WorkoutLocationType.fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'indoor':
        return WorkoutLocationType.indoor;
      case 'outdoor':
        return WorkoutLocationType.outdoor;
      default:
        return WorkoutLocationType.unknown;
    }
  }
}
