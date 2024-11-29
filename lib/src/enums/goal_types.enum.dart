// ignore_for_file: public_member_api_docs

enum WorkoutGoalType {
  distance(label: 'Distance', symbol: 'dist'),
  time(label: 'Time', symbol: 't'),
  energy(label: 'Energy', symbol: 'E'),
  open(label: 'Open', symbol: '∞');

  final String label;
  final String symbol;
  const WorkoutGoalType({required this.label, required this.symbol});
}

enum GoalDistanceUnits {
  kilometers(label: 'Kilometers', symbol: 'km'),
  miles(label: 'Miles', symbol: 'mi'),
  meters(label: 'Meters', symbol: 'm'),
  yards(label: 'Yards', symbol: 'yd');

  final String label;
  final String symbol;
  const GoalDistanceUnits({required this.label, required this.symbol});
}

enum GoalTimeUnits {
  minutes(label: 'Minutes', symbol: 'min'),
  hours(label: 'Hours', symbol: 'hr'),
  seconds(label: 'Seconds', symbol: 's');

  final String label;
  final String symbol;
  const GoalTimeUnits({required this.label, required this.symbol});
}

enum GoalEnergyUnits {
  calories(label: 'Calories', symbol: 'cal'),
  kilocalories(label: 'Kilocalories', symbol: 'kcal');

  final String label;
  final String symbol;
  const GoalEnergyUnits({required this.label, required this.symbol});
}

enum WorkoutGoalUnit {
  kilometers(label: 'Kilometers', symbol: 'km'),
  miles(label: 'Miles', symbol: 'mi'),
  meters(label: 'Meters', symbol: 'm'),
  yards(label: 'Yards', symbol: 'yd'),
  minutes(label: 'Minutes', symbol: 'min'),
  hours(label: 'Hours', symbol: 'hr'),
  seconds(label: 'Seconds', symbol: 's'),
  calories(label: 'Calories', symbol: 'cal'),
  kilocalories(label: 'Kilocalories', symbol: 'kcal'),
  open(label: 'Open', symbol: '∞');

  final String label;
  final String symbol;
  const WorkoutGoalUnit({required this.label, required this.symbol});
}
