// ignore_for_file: public_member_api_docs

enum WorkoutSwimmingLocationType {
  unknown,
  openWater,
  pool;

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

  bool get isOpenWater => this == WorkoutSwimmingLocationType.openWater;
  bool get isPool => this == WorkoutSwimmingLocationType.pool;
  bool get isUnknown => this == WorkoutSwimmingLocationType.unknown;

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
