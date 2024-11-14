enum WorkoutSwimmingLocationType {
  unknown,
  openWater,
  pool;

  // Convert enum to string representation
  String toDisplayString() {
    switch (this) {
      case WorkoutSwimmingLocationType.unknown:
        return 'Unknown';
      case WorkoutSwimmingLocationType.openWater:
        return 'Open Water';
      case WorkoutSwimmingLocationType.pool:
        return 'Pool';
    }
  }

  // Helper getters
  bool get isOpenWater => this == WorkoutSwimmingLocationType.openWater;
  bool get isPool => this == WorkoutSwimmingLocationType.pool;
  bool get isUnknown => this == WorkoutSwimmingLocationType.unknown;

  // Factory constructor to handle string conversion
  factory WorkoutSwimmingLocationType.fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'openwater':
        return WorkoutSwimmingLocationType.openWater;
      case 'pool':
        return WorkoutSwimmingLocationType.pool;
      default:
        return WorkoutSwimmingLocationType.unknown;
    }
  }
}
