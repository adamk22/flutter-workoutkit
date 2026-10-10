// Runs against the real iOS plugin in a simulator or on a device:
//   cd example && flutter test integration_test
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:flutter_workoutkit/flutter_workoutkit.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('getPlatformVersion', (tester) async {
    final version = await Workoutkit.getPlatformVersion();
    expect(version, startsWith('iOS '));
  });

  testWidgets('all samples are valid WorkoutKit workouts', (tester) async {
    final samples = <Workout>[
      sampleSpeedCyclingWorkout,
      sampleCustomWorkout,
      sample10kTrainingRun,
      sample21kmTrainingRun,
      sampleTempoPaceRun,
      samplePoolSwimIntervals,
      samplePacerMinutesWorkout,
      samplePacerHoursWorkout,
      sampleSingleGoalTimedWorkout,
      sampleSingleGoalEnergyWorkout,
      sampleSingleOpenWorkout,
      sampleSingleGoalSwimmingWorkout,
      sampleSwimBikeRunWorkout,
    ];
    for (final sample in samples) {
      final result = await Workoutkit.validate(sample);
      expect(result.isValid, isTrue, reason: '${sample.toJson()}: $result');
    }
  });

  testWidgets('validate reports unsupported workouts', (tester) async {
    final result = await Workoutkit.validate(PacerWorkout(
      activityType: WorkoutActivityType.archery,
      location: WorkoutLocationType.outdoor,
      targetValue: 1,
      targetValueUnit: GoalDistanceUnits.kilometers,
      targetDuration: const Duration(minutes: 10),
      targetDurationUnit: GoalTimeUnits.minutes,
    ));
    expect(result.isValid, isFalse);
    expect(result.issues, isNotEmpty);
  });

  testWidgets('export / import round-trips', (tester) async {
    final data = await Workoutkit.exportWorkout(sampleTempoPaceRun);
    expect(data, isNotEmpty);
    final imported = await Workoutkit.importWorkout(data);
    expect(imported, isA<CustomWorkout>());
    expect((imported as CustomWorkout).displayName, 'Tempo Run');
    // Pace alerts come back as speed alerts.
    expect(imported.blocks.first.steps.first.alert, isA<SpeedRangeAlert>());
  });

  testWidgets('scheduler queries work without a paired watch', (tester) async {
    expect(await WorkoutScheduler.isSupported(), isA<bool>());
    expect(await WorkoutScheduler.maxAllowedScheduledWorkoutCount(),
        greaterThan(0));
  });

  testWidgets('preview button renders a native view', (tester) async {
    WorkoutkitException? error;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: WorkoutPreviewButton(
          workout: sampleCustomWorkout,
          onError: (e) => error = e,
        ),
      ),
    ));
    await tester.pumpAndSettle();
    expect(find.byType(UiKitView), findsOneWidget);
    expect(error, isNull);
  });

  testWidgets('preview button reports unsupported workouts', (tester) async {
    WorkoutkitException? error;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: WorkoutPreviewButton(
          workout: SingleGoalWorkout(
            activityType: WorkoutActivityType.archery,
            location: WorkoutLocationType.outdoor,
            goal: const WorkoutGoal.distance(5, WorkoutGoalUnit.kilometers),
          ),
          onError: (e) => error = e,
        ),
      ),
    ));
    await tester.pumpAndSettle();
    expect(error?.code, WorkoutkitErrorCode.unsupportedWorkout);
  });
}
