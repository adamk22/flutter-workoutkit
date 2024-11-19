class WorkoutAlert {
  final WorkoutAlertType type;
  final double? threshold;
  final double? lowerBound;
  final double? upperBound;
  final int? zone;
  final WorkoutAlertMetric? metric;
  final UnitSpeed? unitSpeed;

  WorkoutAlert({
    required this.type,
    this.threshold,
    this.lowerBound,
    this.upperBound,
    this.zone,
    this.metric,
    this.unitSpeed,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type.toString().split('.').last,
      'threshold': threshold,
      'lowerBound': lowerBound,
      'upperBound': upperBound,
      'zone': zone,
      'metric': metric?.toString().split('.').last,
      'unitSpeed': unitSpeed?.toString().split('.').last,
    };
  }
}

enum UnitSpeed {
  metersPerSecond(symbol: 'm/s', coefficient: 1.0),
  kilometersPerHour(symbol: 'km/h', coefficient: 0.277778),
  milesPerHour(symbol: 'mph', coefficient: 0.44704),
  knots(symbol: 'kn', coefficient: 0.514444);

  final String symbol;
  final double coefficient;

  const UnitSpeed({
    required this.symbol,
    required this.coefficient,
  });
}

enum WorkoutAlertMetric { average, current }

// TODO: Add paceRange and paceThreshold and its relevant class properties
enum WorkoutAlertType {
  cadenceRange,
  cadenceThreshold,
  heartRateRange,
  heartRateZone,
  powerRange,
  powerThreshold,
  powerZone,
  speedRange,
  speedThreshold,
  // paceRange,
  // paceThreshold,
}
