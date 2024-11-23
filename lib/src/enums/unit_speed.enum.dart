// ignore_for_file: public_member_api_docs

enum UnitSpeed {
  metersPerSecond(symbol: 'metersPerSecond'),
  kilometersPerHour(symbol: 'kilometersPerHour'),
  milesPerHour(symbol: 'milesPerHour'),
  knots(symbol: 'knots');

  final String symbol;

  const UnitSpeed({
    required this.symbol,
  });

  /// Creates a new unit speed from a string
  static UnitSpeed fromString(String symbol) {
    return UnitSpeed.values.firstWhere((e) => e.symbol == symbol);
  }
}
