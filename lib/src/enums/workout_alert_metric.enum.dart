// ignore_for_file: public_member_api_docs

enum WorkoutAlertMetric {
  average(label: 'Average', symbol: 'average'),
  current(label: 'Current', symbol: 'current');

  final String label;
  final String symbol;

  const WorkoutAlertMetric({
    required this.label,
    required this.symbol,
  });

  /// Creates a new workout alert metric from a string
  static WorkoutAlertMetric fromString(String metric) {
    return WorkoutAlertMetric.values.firstWhere((e) => e.symbol == metric);
  }
}
