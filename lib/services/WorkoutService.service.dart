import 'package:flutter/services.dart';
import 'package:flutter_workoutkit/mockData/mock_custom_workout.dart';

class WorkoutService {
  static Future<void> startWorkout() async {
    // Example workout creation
    final customWorkout = mockCustomWorkout;

    try {
      await const MethodChannel('workoutkit').invokeMethod(
        'createCustomWorkout',
        customWorkout.toJson(),
      );
    } catch (e) {
      print('Error creating workout: $e');
    }
  }
}
