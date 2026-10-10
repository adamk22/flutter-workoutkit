/// Whether an alert compares against the current or the average value.
enum WorkoutAlertMetric {
  /// Average over the step.
  average(label: 'Average', symbol: 'average'),

  /// Current (instantaneous) value.
  current(label: 'Current', symbol: 'current');

  /// Human readable label.
  final String label;

  /// Serialized symbol (same as [name]).
  final String symbol;

  const WorkoutAlertMetric({required this.label, required this.symbol});

  /// Looks up a metric by its [name].
  static WorkoutAlertMetric fromString(String metric) =>
      WorkoutAlertMetric.values.byName(metric);
}
