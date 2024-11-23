// ignore_for_file: public_member_api_docs

enum WorkoutAlertType {
  cadenceRange(symbol: 'cadenceRange'),
  cadenceThreshold(symbol: 'cadenceThreshold'),
  heartRateRange(symbol: 'heartRateRange'),
  heartRateZone(symbol: 'heartRateZone'),
  powerRange(symbol: 'powerRange'),
  powerThreshold(symbol: 'powerThreshold'),
  powerZone(symbol: 'powerZone'),
  speedRange(symbol: 'speedRange'),
  speedThreshold(symbol: 'speedThreshold'),
  paceRange(symbol: 'paceRange'),
  paceThreshold(symbol: 'paceThreshold');

  final String symbol;

  const WorkoutAlertType({required this.symbol});

  /// Creates a new workout alert type from a string
  static WorkoutAlertType fromString(String type) {
    return WorkoutAlertType.values.firstWhere((e) => e.toString() == type);
  }
}
