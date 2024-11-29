// ignore_for_file: public_member_api_docs

enum UnitSpeed {
  metersPerSecond(label: 'Meters per Second', symbol: 'm/s'),
  kilometersPerHour(label: 'Kilometers per Hour', symbol: 'kph'),
  milesPerHour(label: 'Miles per Hour', symbol: 'mph'),
  knots(label: 'Knots', symbol: 'knots');

  final String label;
  final String symbol;

  const UnitSpeed({
    required this.label,
    required this.symbol,
  });

  /// Creates a new unit speed from a string
  static UnitSpeed fromString(String symbol) {
    return UnitSpeed.values.firstWhere((e) => e.symbol == symbol);
  }
}
