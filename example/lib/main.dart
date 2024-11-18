import 'dart:convert';

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
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await _workoutkitPlugin.getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
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
          title: const Text('Plugin example app'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ElevatedButton(
                onPressed: () => _workoutkitPlugin.requestHealthPermissions(),
                child: Text('Request Health Permissions'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Center(
                child: Text('Running on: $_platformVersion\n'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: WorkoutPreviewButton(
                  workout: mockPacerHoursWorkout,
                  buttonTitle: '[Pacer] 2 Hour Cycle'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: WorkoutPreviewButton(
                  workout: mockPacerMinutesWorkout,
                  buttonTitle: '[Pacer] 30 Minute Run'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: WorkoutPreviewButton(
                  workout: mockCustomWorkout,
                  buttonTitle: '[Custom] Timed Workout'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: WorkoutPreviewButton(
                  workout: mock10kTrainingRun,
                  buttonTitle: '[Custom] 10k Training Run'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: WorkoutPreviewButton(
                  workout: mockSingleGoalTimedWorkout,
                  buttonTitle: '[Single] Timed Workout'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: WorkoutPreviewButton(
                  workout: mockSingleGoalEnergyWorkout,
                  buttonTitle: '[Single] Energy Workout'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: WorkoutPreviewButton(
                  workout: mockSingleOpenWorkout,
                  buttonTitle: '[Single] Open Workout'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: WorkoutPreviewButton(
                  workout: mockSingleGoalSwimmingWorkout,
                  buttonTitle: '[Single] Swimming Workout'),
            ),
          ],
        ),
      ),
    );
  }
}
