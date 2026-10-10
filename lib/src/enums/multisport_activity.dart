/// The legs available in a [SwimBikeRunWorkout].
enum MultisportActivityType {
  /// Cycling leg.
  cycling(label: 'Cycling'),

  /// Running leg.
  running(label: 'Running'),

  /// Swimming leg.
  swimming(label: 'Swimming');

  /// Human readable label.
  final String label;

  const MultisportActivityType({required this.label});

  /// Looks up an activity by its [name].
  static MultisportActivityType fromString(String name) =>
      MultisportActivityType.values.byName(name);
}
