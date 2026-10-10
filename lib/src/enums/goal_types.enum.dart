/// The kind of goal a [WorkoutGoal] represents.
enum WorkoutGoalType {
  /// Complete a distance.
  distance(label: 'Distance', symbol: 'dist'),

  /// Complete a duration.
  time(label: 'Time', symbol: 't'),

  /// Burn an amount of active energy.
  energy(label: 'Energy', symbol: 'E'),

  /// No goal; the user ends the workout or step manually.
  open(label: 'Open', symbol: '∞'),

  /// Swim a pool distance within a duration. Requires iOS 18.0+.
  poolSwimDistanceWithTime(
      label: 'Pool Swim Distance With Time', symbol: 'swim');

  /// Human readable label.
  final String label;

  /// Short symbol.
  final String symbol;

  const WorkoutGoalType({required this.label, required this.symbol});

  /// Looks up a goal type by its [name].
  static WorkoutGoalType fromString(String name) =>
      WorkoutGoalType.values.byName(name);
}

/// Distance units used by [PacerWorkout].
enum GoalDistanceUnits {
  /// Kilometers.
  kilometers(label: 'Kilometers', symbol: 'km'),

  /// Miles.
  miles(label: 'Miles', symbol: 'mi'),

  /// Meters.
  meters(label: 'Meters', symbol: 'm'),

  /// Yards.
  yards(label: 'Yards', symbol: 'yd');

  /// Human readable label.
  final String label;

  /// Unit symbol.
  final String symbol;

  const GoalDistanceUnits({required this.label, required this.symbol});

  /// Looks up a unit by its [name].
  static GoalDistanceUnits fromString(String name) =>
      GoalDistanceUnits.values.byName(name);
}

/// Time units used by [PacerWorkout].
enum GoalTimeUnits {
  /// Minutes.
  minutes(label: 'Minutes', symbol: 'min'),

  /// Hours.
  hours(label: 'Hours', symbol: 'hr'),

  /// Seconds.
  seconds(label: 'Seconds', symbol: 's');

  /// Human readable label.
  final String label;

  /// Unit symbol.
  final String symbol;

  const GoalTimeUnits({required this.label, required this.symbol});

  /// Looks up a unit by its [name].
  static GoalTimeUnits fromString(String name) =>
      GoalTimeUnits.values.byName(name);
}

/// Energy units.
enum GoalEnergyUnits {
  /// Small (thermochemical) calories. 1000 calories = 1 kilocalorie.
  calories(label: 'Calories', symbol: 'cal'),

  /// Kilocalories — what fitness apps usually call "Calories".
  kilocalories(label: 'Kilocalories', symbol: 'kcal');

  /// Human readable label.
  final String label;

  /// Unit symbol.
  final String symbol;

  const GoalEnergyUnits({required this.label, required this.symbol});

  /// Looks up a unit by its [name].
  static GoalEnergyUnits fromString(String name) =>
      GoalEnergyUnits.values.byName(name);
}

/// Units for a [WorkoutGoal]. Use a distance unit for distance goals, a time
/// unit for time goals and an energy unit for energy goals.
enum WorkoutGoalUnit {
  /// Kilometers.
  kilometers(label: 'Kilometers', symbol: 'km'),

  /// Miles.
  miles(label: 'Miles', symbol: 'mi'),

  /// Meters.
  meters(label: 'Meters', symbol: 'm'),

  /// Yards.
  yards(label: 'Yards', symbol: 'yd'),

  /// Minutes.
  minutes(label: 'Minutes', symbol: 'min'),

  /// Hours.
  hours(label: 'Hours', symbol: 'hr'),

  /// Seconds.
  seconds(label: 'Seconds', symbol: 's'),

  /// Small (thermochemical) calories. 1000 calories = 1 kilocalorie.
  calories(label: 'Calories', symbol: 'cal'),

  /// Kilocalories — what fitness apps usually call "Calories".
  kilocalories(label: 'Kilocalories', symbol: 'kcal'),

  /// No unit (open goals).
  open(label: 'Open', symbol: '∞');

  /// Human readable label.
  final String label;

  /// Unit symbol.
  final String symbol;

  const WorkoutGoalUnit({required this.label, required this.symbol});

  /// Whether this is a distance unit.
  bool get isDistance =>
      const [kilometers, miles, meters, yards].contains(this);

  /// Whether this is a time unit.
  bool get isTime => const [minutes, hours, seconds].contains(this);

  /// Whether this is an energy unit.
  bool get isEnergy => const [calories, kilocalories].contains(this);

  /// Looks up a unit by its [name].
  static WorkoutGoalUnit fromString(String name) =>
      WorkoutGoalUnit.values.byName(name);
}
