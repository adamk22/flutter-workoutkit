import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_workoutkit/flutter_workoutkit.dart';

void main() {
  Widget host(Widget child) => MaterialApp(home: Scaffold(body: child));

  testWidgets('renders nothing on Android', (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    await tester
        .pumpWidget(host(WorkoutPreviewButton(workout: sampleCustomWorkout)));
    expect(find.byType(UiKitView), findsNothing);
    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets('renders a UiKitView with the workout and style on iOS',
      (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    await tester.pumpWidget(host(WorkoutPreviewButton(
      workout: sampleCustomWorkout,
      buttonTitle: 'Go',
      sfSymbol: 'applewatch',
      backgroundColor: const Color(0xFF112233),
      fontWeight: FontWeight.w700,
    )));

    final view = tester.widget<UiKitView>(find.byType(UiKitView));
    expect(view.viewType, 'workout_preview_button');
    final params = view.creationParams as Map<String, dynamic>;
    expect(params['workoutJson'], sampleCustomWorkout.toJson());
    expect(params['buttonTitle'], 'Go');
    expect(params['sfSymbol'], 'applewatch');
    expect(params['backgroundColor'], 0xFF112233);
    expect(params['fontWeight'], 'w700');
    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets('has no icon by default', (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    await tester
        .pumpWidget(host(WorkoutPreviewButton(workout: sampleCustomWorkout)));
    final view = tester.widget<UiKitView>(find.byType(UiKitView));
    expect((view.creationParams as Map)['sfSymbol'], isNull);
    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets('recreates the native view when the workout changes',
      (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    await tester
        .pumpWidget(host(WorkoutPreviewButton(workout: sampleCustomWorkout)));
    final first = tester.widget<UiKitView>(find.byType(UiKitView)).key;
    await tester
        .pumpWidget(host(WorkoutPreviewButton(workout: sample10kTrainingRun)));
    final second = tester.widget<UiKitView>(find.byType(UiKitView)).key;
    expect(first, isNot(second));
    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets('reports native build errors through onError', (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

    // Fake the platform views service; when the native view is "created",
    // answer its per-view channel with a build error.
    MethodChannel? viewChannel;
    messenger.setMockMethodCallHandler(SystemChannels.platform_views,
        (call) async {
      if (call.method == 'create') {
        final id = (call.arguments as Map)['id'] as int;
        viewChannel = MethodChannel('workout_preview_button_$id');
        messenger.setMockMethodCallHandler(viewChannel!, (call) async {
          expect(call.method, 'getBuildError');
          return {'code': 'UNSUPPORTED_OS', 'message': 'needs iOS 18'};
        });
      }
      return null;
    });

    WorkoutkitException? reported;
    await tester.pumpWidget(host(WorkoutPreviewButton(
      workout: samplePoolSwimIntervals,
      onError: (e) => reported = e,
    )));
    await tester.pumpAndSettle();

    expect(reported?.code, 'UNSUPPORTED_OS');
    messenger.setMockMethodCallHandler(viewChannel!, null);
    messenger.setMockMethodCallHandler(SystemChannels.platform_views, null);
    debugDefaultTargetPlatformOverride = null;
  });
}
