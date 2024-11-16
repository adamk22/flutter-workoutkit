import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WorkoutPreviewButton extends StatelessWidget {
  final Map<String, dynamic> workoutJson;

  const WorkoutPreviewButton({
    Key? key,
    required this.workoutJson,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!Platform.isIOS) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 50, // Adjust height as needed
      child: UiKitView(
        viewType: 'workout_preview_button',
        creationParams: workoutJson,
        creationParamsCodec: const StandardMessageCodec(),
      ),
    );
  }
}
