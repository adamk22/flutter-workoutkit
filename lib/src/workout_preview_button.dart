import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'classes/index.dart';

class WorkoutPreviewButton extends StatelessWidget {
  final Workout workout;
  final String? buttonTitle;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? cornerRadiusSize;
  final double? buttonHeight;
  final double? fontSize;
  final FontWeight? fontWeight;

  const WorkoutPreviewButton({
    super.key,
    required this.workout,
    this.buttonTitle = 'Preview & Start Workout',
    this.backgroundColor = const Color.fromARGB(255, 0, 0, 0),
    this.foregroundColor = const Color.fromARGB(255, 255, 255, 255),
    this.cornerRadiusSize = 10,
    this.buttonHeight = 54,
    this.fontSize = 16,
    this.fontWeight = FontWeight.w400,
  });

  @override
  Widget build(BuildContext context) {
    if (!Platform.isIOS) {
      return const SizedBox.shrink();
    }

    final workoutJson = workout.toJson();

    return SizedBox(
      height: buttonHeight,
      child: UiKitView(
        viewType: 'workout_preview_button',
        creationParams: {
          'workoutJson': workoutJson,
          'buttonTitle': buttonTitle,
          'backgroundColor': backgroundColor?.value ?? Colors.black.value,
          'foregroundColor': foregroundColor?.value ?? Colors.white.value,
          'cornerRadiusSize': cornerRadiusSize,
          'buttonHeight': buttonHeight,
          'fontSize': fontSize,
          'fontWeight': fontWeight?.toString().toLowerCase().split('.').last,
        },
        creationParamsCodec: const StandardMessageCodec(),
      ),
    );
  }
}
