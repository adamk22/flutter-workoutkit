enum UnitSpeed {
  metersPerSecond(symbol: 'm/s'),
  kilometersPerHour(symbol: 'km/h'),
  milesPerHour(symbol: 'mph'),
  knots(symbol: 'kn');

  final String symbol;

  const UnitSpeed({
    required this.symbol,
  });
}
