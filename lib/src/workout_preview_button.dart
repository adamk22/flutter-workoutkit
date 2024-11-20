import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'classes/index.dart';

class WorkoutPreviewButton extends StatelessWidget {
  final Workout workout;
  final String buttonTitle;

  const WorkoutPreviewButton({
    super.key,
    required this.workout,
    this.buttonTitle = 'Preview & Start Workout',
  });

  @override
  Widget build(BuildContext context) {
    if (!Platform.isIOS) {
      return const SizedBox.shrink();
    }

    final workoutJson = workout.toJson();

    return SizedBox(
      height: 50, // Adjust height as needed
      child: UiKitView(
        viewType: 'workout_preview_button',
        creationParams: {
          'workoutJson': workoutJson,
          'buttonTitle': buttonTitle,
        },
        creationParamsCodec: const StandardMessageCodec(),
      ),
    );
  }
}
