import 'package:flutter_workoutkit/src/utils/json.dart';

import '../index.dart';

/// A group of [IntervalStep]s repeated [iterations] times.
class IntervalBlock {
  /// The number of iterations of the block.
  final int iterations;

  /// The steps of the block.
  final List<IntervalStep> steps;

  /// Not used by WorkoutKit; the purpose lives on each [IntervalStep].
  @Deprecated('Not used by WorkoutKit. Set IntervalStep.purpose instead.')
  final IntervalBlockType? type;

  /// Creates a new interval block.
  IntervalBlock({
    required this.iterations,
    required this.steps,
    @Deprecated('Not used by WorkoutKit. Set IntervalStep.purpose instead.')
    this.type,
  }) : assert(iterations >= 1, 'iterations must be at least 1');

  /// Converts the interval block to a JSON object.
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'iterations': iterations,
      'steps': steps.map((step) => step.toJson()).toList(),
    };
    // ignore: deprecated_member_use_from_same_package
    putIfNotNull(json, 'type', type?.name);
    return json;
  }

  /// Creates a new interval block from a JSON object.
  static IntervalBlock fromJson(Map<String, dynamic> json) {
    return IntervalBlock(
      iterations: (json['iterations'] as num).toInt(),
      steps: asJsonList(json['steps']).map(IntervalStep.fromJson).toList(),
      // ignore: deprecated_member_use_from_same_package
      type: json['type'] != null
          ? IntervalBlockType.values.byName(json['type'] as String)
          : null,
    );
  }
}

/// Not used by WorkoutKit; kept for backwards compatibility.
enum IntervalBlockType {
  /// A work block.
  work,

  /// A recovery block.
  recovery,

  /// A work recovery block.
  workRecovery,
}
