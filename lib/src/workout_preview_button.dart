import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'classes/index.dart';
import 'utils/json.dart';
import 'workoutkit_exception.dart';

/// A native button that opens WorkoutKit's workout preview sheet, from which
/// the user can add the workout to the Workout app on their Apple Watch.
///
/// WorkoutKit only allows presenting the preview from a SwiftUI view, so this
/// widget embeds a native button. On platforms other than iOS it renders
/// nothing.
class WorkoutPreviewButton extends StatefulWidget {
  /// The workout to preview.
  final Workout workout;

  /// The title of the button.
  final String? buttonTitle;

  /// The background color of the button.
  final Color? backgroundColor;

  /// The foreground color of the button.
  final Color? foregroundColor;

  /// The corner radius size of the button.
  final double? cornerRadiusSize;

  /// The height of the button.
  final double? buttonHeight;

  /// The font size of the button.
  final double? fontSize;

  /// The font weight of the button.
  final FontWeight? fontWeight;

  /// An optional SF Symbol name shown before the title, e.g. `applewatch`.
  final String? sfSymbol;

  /// Called when the native side can't build the workout, e.g. because it
  /// uses a feature that needs a newer iOS version. The button renders empty
  /// in that case.
  final ValueChanged<WorkoutkitException>? onError;

  /// Creates a new workout preview button.
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
    this.sfSymbol,
    this.onError,
  });

  /// The platform view type registered by the iOS plugin.
  static const viewType = 'workout_preview_button';

  @override
  State<WorkoutPreviewButton> createState() => _WorkoutPreviewButtonState();
}

class _WorkoutPreviewButtonState extends State<WorkoutPreviewButton> {
  MethodChannel? _viewChannel;

  Map<String, dynamic> get _creationParams => {
        'workoutJson': widget.workout.toJson(),
        'buttonTitle': widget.buttonTitle,
        'backgroundColor': (widget.backgroundColor ?? Colors.black).toARGB32(),
        'foregroundColor': (widget.foregroundColor ?? Colors.white).toARGB32(),
        'cornerRadiusSize': widget.cornerRadiusSize,
        'buttonHeight': widget.buttonHeight,
        'fontSize': widget.fontSize,
        'fontWeight': widget.fontWeight?.toString().split('.').last,
        'sfSymbol': widget.sfSymbol,
      };

  Future<void> _onPlatformViewCreated(int id) async {
    final channel = MethodChannel('${WorkoutPreviewButton.viewType}_$id');
    _viewChannel = channel;
    try {
      final error = await channel.invokeMethod<Map>('getBuildError');
      if (error != null && mounted && _viewChannel == channel) {
        final json = asJsonMap(error);
        widget.onError?.call(WorkoutkitException(
          json['code'] as String,
          json['message'] as String?,
        ));
      }
    } on MissingPluginException {
      // Older native side without the per-view channel.
    }
  }

  @override
  void dispose() {
    _viewChannel = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.iOS) {
      return const SizedBox.shrink();
    }

    final params = _creationParams;
    return SizedBox(
      height: widget.buttonHeight,
      child: UiKitView(
        // Platform views ignore new creation params, so recreate the native
        // view whenever the workout or styling changes.
        key: ValueKey(jsonEncode(params)),
        viewType: WorkoutPreviewButton.viewType,
        creationParams: params,
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: _onPlatformViewCreated,
      ),
    );
  }
}
