// ignore_for_file: public_member_api_docs

enum WorkoutLocationType {
  unknown,
  indoor,
  outdoor;

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
