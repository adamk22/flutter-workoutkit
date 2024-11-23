import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_workoutkit/workoutkit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  bool _hasHealthPermissions = false;
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    try {
      platformVersion =
          await Workoutkit.getPlatformVersion() ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }
    if (!mounted) return;
    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter WorkoutKit Example'),
        ),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ElevatedButton(
                      onPressed: () => Workoutkit.requestHealthPermissions(),
                      child: const Text('Request Health Permissions'),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ElevatedButton(
                      onPressed: () =>
                          Workoutkit.hasHealthPermissions().then((value) {
                        setState(() {
                          _hasHealthPermissions = value;
                        });
                      }),
                      child: const Text('Check Health Permissions'),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child:
                        Text('Has Health Permissions: $_hasHealthPermissions'),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Center(
                      child: Text('Running on: $_platformVersion\n'),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: WorkoutPreviewButton(
                        workout: sampleSwimBikeRunWorkout,
                        buttonTitle: '[SwimBikeRun] Triathlon Training'),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: WorkoutPreviewButton(
                        workout: samplePacerHoursWorkout,
                        buttonTitle: '[Pacer] 2 Hour Cycle'),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: WorkoutPreviewButton(
                        workout: samplePacerMinutesWorkout,
                        buttonTitle: '[Pacer] 30 Minute Run'),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: WorkoutPreviewButton(
                        workout: sampleSpeedCyclingWorkout,
                        buttonTitle: '[Custom] Speed Cycling'),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: WorkoutPreviewButton(
                        workout: sampleCustomWorkout,
                        buttonTitle: '[Custom] Timed Workout'),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: WorkoutPreviewButton(
                        workout: sample10kTrainingRun,
                        buttonTitle: '[Custom] 10k Training Run'),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: WorkoutPreviewButton(
                        workout: sample21kmTrainingRun,
                        buttonTitle: '[Custom] 21k Stepped Run'),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: WorkoutPreviewButton(
                        workout: sampleSingleGoalTimedWorkout,
                        buttonTitle: '[Single] Timed Workout'),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: WorkoutPreviewButton(
                        workout: sampleSingleGoalEnergyWorkout,
                        buttonTitle: '[Single] Energy Workout'),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: WorkoutPreviewButton(
                        workout: sampleSingleOpenWorkout,
                        buttonTitle: '[Single] Open Workout'),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: WorkoutPreviewButton(
                        workout: sampleSingleGoalSwimmingWorkout,
                        buttonTitle: '[Single] Swimming Workout'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
