// ignore_for_file: public_member_api_docs

enum WorkoutAlertType {
  cadenceRange(label: 'Cadence Range', symbol: 'cadenceRange'),
  cadenceThreshold(label: 'Cadence Threshold', symbol: 'cadenceThreshold'),
  heartRateRange(label: 'Heart Rate Range', symbol: 'heartRateRange'),
  heartRateZone(label: 'Heart Rate Zone', symbol: 'heartRateZone'),
  powerRange(label: 'Power Range', symbol: 'powerRange'),
  powerThreshold(label: 'Power Threshold', symbol: 'powerThreshold'),
  powerZone(label: 'Power Zone', symbol: 'powerZone'),
  speedRange(label: 'Speed Range', symbol: 'speedRange'),
  speedThreshold(label: 'Speed Threshold', symbol: 'speedThreshold'),
  paceRange(label: 'Pace Range', symbol: 'paceRange'),
  paceThreshold(label: 'Pace Threshold', symbol: 'paceThreshold');

  final String label;
  final String symbol;

  const WorkoutAlertType({
    required this.label,
    required this.symbol,
  });

  /// Creates a new workout alert type from a string
  static WorkoutAlertType fromString(String type) {
    return WorkoutAlertType.values.firstWhere((e) => e.toString() == type);
  }
}
