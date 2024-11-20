import '../index.dart';

class IntervalBlock {
  final int iterations;
  final List<IntervalStep> steps;
  final IntervalBlockType type;

  IntervalBlock({
    required this.iterations,
    required this.steps,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      'iterations': iterations,
      'steps': steps.map((step) => step.toJson()).toList(),
      'type': type.toString().split('.').last,
    };
  }
}

enum IntervalBlockType {
  work,
  recovery,
  workRecovery,
}
