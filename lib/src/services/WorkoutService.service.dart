import 'package:flutter/services.dart';
import '../samples/sample_custom_workout.dart';

/// Represents a workout service
@Deprecated(
    'This service is deprecated and will be removed in a future version.')
class WorkoutService {
  /// Starts a workout
  static Future<void> startWorkout() async {
    // Example workout creation
    final customWorkout = sampleCustomWorkout;

    try {
      await const MethodChannel('workoutkit').invokeMethod(
        'createCustomWorkout',
        customWorkout.toJson(),
      );
    } catch (e) {
      throw Exception('Error creating workout: $e');
    }
  }
}
