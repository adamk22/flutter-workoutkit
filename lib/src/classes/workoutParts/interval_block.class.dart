import '../index.dart';

/// Represents an interval block
class IntervalBlock {
  /// The number of iterations of the block
  final int iterations;

  /// The steps of the block
  final List<IntervalStep> steps;

  /// The type of the block
  final IntervalBlockType type;

  /// Creates a new interval block
  IntervalBlock({
    required this.iterations,
    required this.steps,
    required this.type,
  });

  /// Converts the interval block to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'iterations': iterations,
      'steps': steps.map((step) => step.toJson()).toList(),
      'type': type.toString().split('.').last,
    };
  }
}

/// The type of interval block
enum IntervalBlockType {
  /// A work block
  work,

  /// A recovery block
  recovery,

  /// A work recovery block
  workRecovery,
}
