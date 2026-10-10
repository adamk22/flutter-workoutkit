import 'package:flutter/material.dart';
import 'package:flutter_workoutkit/flutter_workoutkit.dart';

import 'sample_workout.dart';

void main() {
  runApp(const MyApp());
}

/// Samples shown in the example app.
final Map<String, Workout> samples = {
  '[Custom] 5K Training Run': sampleWorkout,
  '[Custom] Tempo Run (pace alerts)': sampleTempoPaceRun,
  '[Custom] Pool Intervals (iOS 18)': samplePoolSwimIntervals,
  '[Custom] Speed Cycling': sampleSpeedCyclingWorkout,
  '[Custom] Timed Workout': sampleCustomWorkout,
  '[Custom] 10k Training Run': sample10kTrainingRun,
  '[Custom] 21k Stepped Run': sample21kmTrainingRun,
  '[Pacer] 2 Hour Cycle': samplePacerHoursWorkout,
  '[Pacer] 30 Minute Run': samplePacerMinutesWorkout,
  '[Single] Timed Workout': sampleSingleGoalTimedWorkout,
  '[Single] Energy Workout': sampleSingleGoalEnergyWorkout,
  '[Single] Open Workout': sampleSingleOpenWorkout,
  '[Single] Swimming Workout': sampleSingleGoalSwimmingWorkout,
  '[SwimBikeRun] Triathlon Training': sampleSwimBikeRunWorkout,
};

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Flutter WorkoutKit Example'),
            bottom: const TabBar(tabs: [
              Tab(text: 'Preview'),
              Tab(text: 'Validate'),
              Tab(text: 'Schedule'),
            ]),
          ),
          body: const TabBarView(children: [
            PreviewTab(),
            ValidateTab(),
            ScheduleTab(),
          ]),
        ),
      ),
    );
  }
}

/// One preview entry per sample, either as the native `WorkoutPreviewButton`
/// or as a Flutter button calling `WorkoutKit.presentPreview`.
class PreviewTab extends StatefulWidget {
  const PreviewTab({super.key});

  @override
  State<PreviewTab> createState() => _PreviewTabState();
}

class _PreviewTabState extends State<PreviewTab> {
  bool _useNativeButton = true;

  void _showError(String name, WorkoutkitException error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$name: ${error.message}')),
    );
  }

  Future<void> _present(String name, Workout workout) async {
    try {
      await WorkoutKit.presentPreview(workout);
    } on WorkoutkitException catch (e) {
      if (mounted) _showError(name, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: SegmentedButton<bool>(
            segments: const [
              ButtonSegment(value: true, label: Text('Native button')),
              ButtonSegment(value: false, label: Text('presentPreview')),
            ],
            selected: {_useNativeButton},
            onSelectionChanged: (v) =>
                setState(() => _useNativeButton = v.first),
          ),
        ),
        for (final entry in samples.entries)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: _useNativeButton
                ? WorkoutPreviewButton(
                    workout: entry.value,
                    buttonTitle: entry.key,
                    sfSymbol: 'applewatch',
                    onError: (error) => _showError(entry.key, error),
                  )
                : SizedBox(
                    height: 54,
                    child: FilledButton.icon(
                      icon: const Icon(Icons.watch),
                      label: Text(entry.key),
                      onPressed: () => _present(entry.key, entry.value),
                    ),
                  ),
          ),
      ],
    );
  }
}

/// Runs `WorkoutKit.validate` on every sample.
class ValidateTab extends StatefulWidget {
  const ValidateTab({super.key});

  @override
  State<ValidateTab> createState() => _ValidateTabState();
}

class _ValidateTabState extends State<ValidateTab> {
  late final Future<Map<String, WorkoutValidationResult>> _results = () async {
    return {
      for (final entry in samples.entries)
        entry.key: await WorkoutKit.validate(entry.value),
    };
  }();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _results,
      builder: (context, snapshot) {
        if (snapshot.hasError) return Center(child: Text('${snapshot.error}'));
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView(
          children: [
            for (final entry in snapshot.data!.entries)
              ListTile(
                leading: Icon(
                  entry.value.isValid ? Icons.check_circle : Icons.error,
                  color: entry.value.isValid ? Colors.green : Colors.red,
                ),
                title: Text(entry.key),
                subtitle: entry.value.isValid
                    ? null
                    : Text(entry.value.issues.join('\n')),
              ),
          ],
        );
      },
    );
  }
}

/// Authorizes and schedules workouts on the paired Apple Watch.
class ScheduleTab extends StatefulWidget {
  const ScheduleTab({super.key});

  @override
  State<ScheduleTab> createState() => _ScheduleTabState();
}

class _ScheduleTabState extends State<ScheduleTab> {
  bool? _supported;
  SchedulerAuthorizationState? _state;
  List<ScheduledWorkout> _scheduled = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _run(Future<void> Function() action) async {
    try {
      await action();
      _error = null;
    } on WorkoutkitException catch (e) {
      _error = '${e.code}: ${e.message}';
    }
    await _refresh();
  }

  Future<void> _refresh() async {
    try {
      final supported = await WorkoutScheduler.isSupported();
      final state = await WorkoutScheduler.authorizationState();
      final scheduled = state == SchedulerAuthorizationState.authorized
          ? await WorkoutScheduler.scheduledWorkouts()
          : <ScheduledWorkout>[];
      if (!mounted) return;
      setState(() {
        _supported = supported;
        _state = state;
        _scheduled = scheduled;
      });
    } on WorkoutkitException catch (e) {
      if (mounted) setState(() => _error = '${e.code}: ${e.message}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authorized = _state == SchedulerAuthorizationState.authorized;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Supported: ${_supported ?? '…'}'),
        Text('Authorization: ${_state?.name ?? '…'}'),
        if (_error != null)
          Text(_error!, style: const TextStyle(color: Colors.red)),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () => _run(WorkoutScheduler.requestAuthorization),
          child: const Text('Request authorization'),
        ),
        ElevatedButton(
          onPressed: authorized
              ? () => _run(() async {
                    final tomorrow =
                        DateTime.now().add(const Duration(days: 1));
                    await WorkoutScheduler.schedule(
                      sampleTempoPaceRun,
                      DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 7),
                    );
                  })
              : null,
          child: const Text('Schedule "Tempo Run" tomorrow at 07:00'),
        ),
        ElevatedButton(
          onPressed: authorized ? () => _run(WorkoutScheduler.removeAll) : null,
          child: const Text('Remove all'),
        ),
        const Divider(),
        for (final scheduled in _scheduled)
          ListTile(
            title: Text(_title(scheduled.workout)),
            subtitle: Text('${scheduled.date}'
                '${scheduled.complete ? ' (complete)' : ''}'),
            trailing: Wrap(children: [
              IconButton(
                icon: const Icon(Icons.check),
                onPressed: () =>
                    _run(() => WorkoutScheduler.markComplete(scheduled)),
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => _run(() => WorkoutScheduler.remove(scheduled)),
              ),
            ]),
          ),
      ],
    );
  }

  String _title(Workout workout) => switch (workout) {
        CustomWorkout(:final displayName) => displayName,
        SwimBikeRunWorkout(:final displayName) =>
          displayName ?? workout.workoutType.label,
        _ => workout.workoutType.label,
      };
}
