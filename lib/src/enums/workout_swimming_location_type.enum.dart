// ignore_for_file: public_member_api_docs

enum WorkoutSwimmingLocationType {
  unknown(label: 'Unknown'),
  openWater(label: 'Open Water'),
  pool(label: 'Pool');

  final String label;
  const WorkoutSwimmingLocationType({required this.label});

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
