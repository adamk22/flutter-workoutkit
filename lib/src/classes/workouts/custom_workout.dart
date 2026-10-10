import 'package:flutter_workoutkit/flutter_workoutkit.dart';
import 'package:flutter_workoutkit/src/utils/json.dart';

/// A workout with an optional warmup, interval blocks and an optional
/// cooldown.
class CustomWorkout extends Workout {
  /// The activity type of the workout.
  final WorkoutActivityType activityType;

  /// The display name of the workout.
  final String displayName;

  /// The warmup step of the workout (optional).
  final WorkoutStep? warmup;

  /// The blocks of the workout.
  final List<IntervalBlock> blocks;

  /// The cooldown step of the workout (optional).
  final WorkoutStep? cooldown;

  /// The location type of the workout.
  final WorkoutLocationType location;

  /// Creates a new custom workout.
  CustomWorkout({
    required this.activityType,
    required this.location,
    required this.displayName,
    this.warmup,
    required this.blocks,
    this.cooldown,
    super.id,
  }) : super(workoutType: WorkoutType.customWorkout);

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson()
      ..addAll({
        'activityType': activityType.name,
        'location': location.name,
        'displayName': displayName,
        'blocks': blocks.map((block) => block.toJson()).toList(),
      });
    putIfNotNull(json, 'warmup', warmup?.toJson());
    putIfNotNull(json, 'cooldown', cooldown?.toJson());
    return json;
  }

  /// Returns a copy with the given fields replaced.
  CustomWorkout copyWith({
    WorkoutActivityType? activityType,
    WorkoutLocationType? location,
    String? displayName,
    WorkoutStep? warmup,
    List<IntervalBlock>? blocks,
    WorkoutStep? cooldown,
    String? id,
  }) {
    return CustomWorkout(
      activityType: activityType ?? this.activityType,
      location: location ?? this.location,
      displayName: displayName ?? this.displayName,
      warmup: warmup ?? this.warmup,
      blocks: blocks ?? this.blocks,
      cooldown: cooldown ?? this.cooldown,
      id: id ?? this.id,
    );
  }

  /// Creates a new custom workout from a JSON object.
  static CustomWorkout fromJson(Map<String, dynamic> json) {
    return CustomWorkout(
      id: json['id'] as String?,
      activityType: WorkoutActivityType.fromString(json['activityType']),
      location: WorkoutLocationType.values.byName(json['location'] as String),
      displayName: json['displayName'] as String,
      warmup: json['warmup'] != null
          ? WorkoutStep.fromJson(asJsonMap(json['warmup']))
          : null,
      blocks: asJsonList(json['blocks']).map(IntervalBlock.fromJson).toList(),
      cooldown: json['cooldown'] != null
          ? WorkoutStep.fromJson(asJsonMap(json['cooldown']))
          : null,
    );
  }
}
