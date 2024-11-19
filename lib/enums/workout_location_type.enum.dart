enum WorkoutLocationType {
  unknown,
  indoor,
  outdoor;

  // Convert enum to string representation
  String toDisplayString() {
    switch (this) {
      case WorkoutLocationType.unknown:
        return 'Unknown';
      case WorkoutLocationType.indoor:
        return 'Indoor';
      case WorkoutLocationType.outdoor:
        return 'Outdoor';
    }
  }

  // Helper getters
  bool get isIndoor => this == WorkoutLocationType.indoor;
  bool get isOutdoor => this == WorkoutLocationType.outdoor;
  bool get isUnknown => this == WorkoutLocationType.unknown;

  // Factory constructor to handle string conversion
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
