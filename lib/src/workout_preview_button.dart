import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'classes/index.dart';

/// Represents a workout preview button
class WorkoutPreviewButton extends StatelessWidget {
  /// The workout to preview
  final Workout workout;

  /// The title of the button
  final String? buttonTitle;

  /// The background color of the button
  final Color? backgroundColor;

  /// The foreground color of the button
  final Color? foregroundColor;

  /// The corner radius size of the button
  final double? cornerRadiusSize;

  /// The height of the button
  final double? buttonHeight;

  /// The font size of the button
  final double? fontSize;

  /// The font weight of the button
  final FontWeight? fontWeight;

  /// Creates a new workout preview button
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
