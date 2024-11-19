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
  final _workoutkitPlugin = Workoutkit();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    try {
      platformVersion = await _workoutkitPlugin.getPlatformVersion() ??
          'Unknown platform version';
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
                      onPressed: () =>
                          _workoutkitPlugin.requestHealthPermissions(),
                      child: const Text('Request Health Permissions'),
                    ),
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
                        workout: mockSwimBikeRunWorkout,
                        buttonTitle: '[SwimBikeRun] Triathlon Training'),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: WorkoutPreviewButton(
                        workout: mockPacerHoursWorkout,
                        buttonTitle: '[Pacer] 2 Hour Cycle'),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: WorkoutPreviewButton(
                        workout: mockPacerMinutesWorkout,
                        buttonTitle: '[Pacer] 30 Minute Run'),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: WorkoutPreviewButton(
                        workout: mockSpeedCyclingWorkout,
                        buttonTitle: '[Custom] Speed Cycling'),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: WorkoutPreviewButton(
                        workout: mockCustomWorkout,
                        buttonTitle: '[Custom] Timed Workout'),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: WorkoutPreviewButton(
                        workout: mock10kTrainingRun,
                        buttonTitle: '[Custom] 10k Training Run'),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: WorkoutPreviewButton(
                        workout: mock21kmTrainingRun,
                        buttonTitle: '[Custom] 21k Stepped Run'),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: WorkoutPreviewButton(
                        workout: mockSingleGoalTimedWorkout,
                        buttonTitle: '[Single] Timed Workout'),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: WorkoutPreviewButton(
                        workout: mockSingleGoalEnergyWorkout,
                        buttonTitle: '[Single] Energy Workout'),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: WorkoutPreviewButton(
                        workout: mockSingleOpenWorkout,
                        buttonTitle: '[Single] Open Workout'),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: WorkoutPreviewButton(
                        workout: mockSingleGoalSwimmingWorkout,
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
