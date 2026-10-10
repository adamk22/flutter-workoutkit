/// The kind of a [WorkoutAlert]. Serialized as the `type` field.
enum WorkoutAlertType {
  /// See [CadenceRangeAlert].
  cadenceRange(label: 'Cadence Range', symbol: 'cadenceRange'),

  /// See [CadenceThresholdAlert].
  cadenceThreshold(label: 'Cadence Threshold', symbol: 'cadenceThreshold'),

  /// See [HeartRateRangeAlert].
  heartRateRange(label: 'Heart Rate Range', symbol: 'heartRateRange'),

  /// See [HeartRateZoneAlert].
  heartRateZone(label: 'Heart Rate Zone', symbol: 'heartRateZone'),

  /// See [PowerRangeAlert].
  powerRange(label: 'Power Range', symbol: 'powerRange'),

  /// See [PowerThresholdAlert].
  powerThreshold(label: 'Power Threshold', symbol: 'powerThreshold'),

  /// See [PowerZoneAlert].
  powerZone(label: 'Power Zone', symbol: 'powerZone'),

  /// See [SpeedRangeAlert].
  speedRange(label: 'Speed Range', symbol: 'speedRange'),

  /// See [SpeedThresholdAlert].
  speedThreshold(label: 'Speed Threshold', symbol: 'speedThreshold'),

  /// See [PaceRangeAlert].
  paceRange(label: 'Pace Range', symbol: 'paceRange'),

  /// See [PaceThresholdAlert].
  paceThreshold(label: 'Pace Threshold', symbol: 'paceThreshold');

  /// Human readable label.
  final String label;

  /// Serialized symbol (same as [name]).
  final String symbol;

  const WorkoutAlertType({required this.label, required this.symbol});

  /// Looks up an alert type by its [name].
  static WorkoutAlertType fromString(String type) =>
      WorkoutAlertType.values.byName(type);
}
