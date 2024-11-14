import 'package:workoutkit/classes/workoutParts/IntervalStep.class.dart';

class IntervalBlock {
  final int iterations;
  final List<IntervalStep> steps;

  IntervalBlock({
    required this.iterations,
    required this.steps,
  });

  Map<String, dynamic> toJson() {
    return {
      'iterations': iterations,
      'steps': steps.map((step) => step.toJson()).toList(),
    };
  }
}
