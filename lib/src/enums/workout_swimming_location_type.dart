/// Where a swimming workout takes place.
enum WorkoutSwimmingLocationType {
  /// Unknown.
  unknown(label: 'Unknown'),

  /// Open water.
  openWater(label: 'Open Water'),

  /// Pool.
  pool(label: 'Pool');

  /// Human readable label.
  final String label;

  const WorkoutSwimmingLocationType({required this.label});

  /// Whether this is [openWater].
  bool get isOpenWater => this == WorkoutSwimmingLocationType.openWater;

  /// Whether this is [pool].
  bool get isPool => this == WorkoutSwimmingLocationType.pool;

  /// Whether this is [unknown].
  bool get isUnknown => this == WorkoutSwimmingLocationType.unknown;

  /// Parses a location case-insensitively, defaulting to [unknown].
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
