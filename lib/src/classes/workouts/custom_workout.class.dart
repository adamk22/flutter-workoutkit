import 'package:flutter_workoutkit/workoutkit.dart';

/// Represents a custom workout
class CustomWorkout extends Workout {
  /// The activity type of the workout
  final WorkoutActivityType activityType;

  /// The display name of the workout
  final String displayName;

  /// The warmup step of the workout (optional)
  final WorkoutStep? warmup;

  /// The blocks of the workout
  final List<IntervalBlock> blocks;

  /// The cooldown step of the workout (optional)
  final WorkoutStep? cooldown;

  /// The location type of the workout
  final WorkoutLocationType location;

  /// Creates a new custom workout
  CustomWorkout({
    required this.activityType,
    required this.location,
    required this.displayName,
    this.warmup,
    required this.blocks,
    this.cooldown,
  }) : super(workoutType: WorkoutType.customWorkout);

  @override
  Map<String, dynamic> toJson() {
    return {
      'activityType': activityType.toString().split('.').last,
      'workoutType': workoutType.toString().split('.').last,
      'location': location.toString().split('.').last,
      'displayName': displayName,
      'warmup': warmup?.toJson(),
      'blocks': blocks.map((block) => block.toJson()).toList(),
      'cooldown': cooldown?.toJson(),
    };
  }

  /// Creates a new custom workout from a JSON object
  static CustomWorkout fromJson(Map<String, dynamic> json) {
    return CustomWorkout(
      activityType: WorkoutActivityType.values
          .firstWhere((e) => e.name == json['activityType']),
      location: WorkoutLocationType.values
          .firstWhere((e) => e.name == json['location']),
      displayName: json['displayName'],
      warmup: json['warmup'] != null
          ? WorkoutStep.fromJson(json['warmup'] as Map<String, dynamic>)
          : null,
      blocks: json['blocks']
          .map((block) => IntervalBlock.fromJson(block as Map<String, dynamic>))
          .toList(),
      cooldown: json['cooldown'] != null
          ? WorkoutStep.fromJson(json['cooldown'] as Map<String, dynamic>)
          : null,
    );
  }
}
