/// Speed units for speed alerts.
enum UnitSpeed {
  /// Meters per second.
  metersPerSecond(label: 'Meters per Second', symbol: 'm/s'),

  /// Kilometers per hour.
  kilometersPerHour(label: 'Kilometers per Hour', symbol: 'kph'),

  /// Miles per hour.
  milesPerHour(label: 'Miles per Hour', symbol: 'mph'),

  /// Knots.
  knots(label: 'Knots', symbol: 'knots');

  /// Human readable label.
  final String label;

  /// Unit symbol.
  final String symbol;

  const UnitSpeed({required this.label, required this.symbol});

  /// Looks up a unit by its [name] (as serialized by `toJson`), falling back
  /// to its [symbol].
  static UnitSpeed fromString(String value) {
    for (final unit in UnitSpeed.values) {
      if (unit.name == value || unit.symbol == value) return unit;
    }
    throw ArgumentError.value(value, 'value', 'Unknown UnitSpeed');
  }
}

/// The distance a pace is measured over, e.g. minutes per kilometer.
enum PaceUnit {
  /// Time per kilometer.
  perKilometer(label: 'per Kilometer', symbol: '/km', meters: 1000),

  /// Time per mile.
  perMile(label: 'per Mile', symbol: '/mi', meters: 1609.344);

  /// Human readable label.
  final String label;

  /// Unit symbol.
  final String symbol;

  /// The distance in meters this pace unit covers.
  final double meters;

  const PaceUnit({
    required this.label,
    required this.symbol,
    required this.meters,
  });

  /// Converts a [pace] in this unit to meters per second.
  double toMetersPerSecond(Duration pace) =>
      meters / (pace.inMicroseconds / Duration.microsecondsPerSecond);

  /// Looks up a unit by its [name].
  static PaceUnit fromString(String name) => PaceUnit.values.byName(name);
}
