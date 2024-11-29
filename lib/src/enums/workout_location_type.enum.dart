// ignore_for_file: public_member_api_docs

enum WorkoutLocationType {
  unknown(label: 'Unknown'),
  indoor(label: 'Indoor'),
  outdoor(label: 'Outdoor');

  final String label;
  const WorkoutLocationType({required this.label});

  bool get isIndoor => this == WorkoutLocationType.indoor;
  bool get isOutdoor => this == WorkoutLocationType.outdoor;
  bool get isUnknown => this == WorkoutLocationType.unknown;

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
