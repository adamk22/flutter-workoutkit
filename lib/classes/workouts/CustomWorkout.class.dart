import 'package:workoutkit/classes/index.dart';

class CustomWorkout extends Workout {
  final String displayName;
  final WorkoutStep? warmup;
  final List<IntervalBlock> blocks;
  final WorkoutStep? cooldown;

  CustomWorkout({
    required super.activityType,
    required super.location,
    required this.displayName,
    this.warmup,
    required this.blocks,
    this.cooldown,
  }) : super();

  Map<String, dynamic> toJson() {
    return {
      'activityType': activityType.toString().split('.').last,
      'location': location.toString().split('.').last,
      'displayName': displayName,
      'warmup': warmup?.toJson(),
      'blocks': blocks.map((block) => block.toJson()).toList(),
      'cooldown': cooldown?.toJson(),
    };
  }
}
