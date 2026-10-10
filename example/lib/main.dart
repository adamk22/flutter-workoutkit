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
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Flutter WorkoutKit Example'),
            bottom: const TabBar(isScrollable: true, tabs: [
              Tab(text: 'Preview'),
              Tab(text: 'Validate'),
              Tab(text: 'Customize'),
              Tab(text: 'Schedule'),
            ]),
          ),
          body: const TabBarView(children: [
            PreviewTab(),
            ValidateTab(),
            CustomizeTab(),
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
      for (final entry in {...samples, ...unsupportedExamples}.entries)
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
                // Structured issues: a code and a path you can use to
                // localize the message or highlight the offending step.
                subtitle: entry.value.isValid
                    ? null
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (final issue in entry.value.details)
                            Text('${issue.code.name}'
                                '${issue.path == null ? '' : ' @ ${issue.path}'}'
                                '\n${issue.message}'),
                        ],
                      ),
              ),
          ],
        );
      },
    );
  }
}

/// Workouts WorkoutKit rejects, to show structured validation issues.
final Map<String, Workout> unsupportedExamples = {
  '[Invalid] Archery pacer': samplePacerMinutesWorkout.copyWith(
    activityType: WorkoutActivityType.archery,
  ),
  '[Invalid] Pool swim goal on a run': sampleTempoPaceRun.copyWith(
    displayName: 'Run with a pool swim step',
    blocks: [
      IntervalBlock(iterations: 1, steps: [
        IntervalStep(
          purpose: IntervalStepPurpose.work,
          goal: const WorkoutGoal.distance(1, WorkoutGoalUnit.kilometers),
        ),
        IntervalStep(
          purpose: IntervalStepPurpose.work,
          goal: const WorkoutGoal.poolSwimDistanceWithTime(
            distance: 100,
            distanceUnit: WorkoutGoalUnit.meters,
            duration: Duration(minutes: 2),
          ),
        ),
      ]),
    ],
  ),
};

/// Builds a variant of the tempo run with `copyWith`, compares it with `==`,
/// round-trips it through WorkoutKit's export format and opens it with
/// `WorkoutKit.presentPreview`.
class CustomizeTab extends StatefulWidget {
  const CustomizeTab({super.key});

  @override
  State<CustomizeTab> createState() => _CustomizeTabState();
}

class _CustomizeTabState extends State<CustomizeTab> {
  int _repeats = 3;
  int _fastestPaceSeconds = 300;
  String? _status;

  CustomWorkout get _workout {
    final base = sampleTempoPaceRun;
    final block = base.blocks.first;
    final work = block.steps.first;
    final pace = work.alert! as PaceRangeAlert;
    return base.copyWith(
      displayName: 'Tempo Run ($_repeats×2 km)',
      blocks: [
        block.copyWith(
          iterations: _repeats,
          steps: [
            work.copyWith(
              alert: pace.copyWith(
                fastestPace: Duration(seconds: _fastestPaceSeconds),
                slowestPace: Duration(seconds: _fastestPaceSeconds + 30),
              ),
            ),
            ...block.steps.skip(1),
          ],
        ),
      ],
    );
  }

  Future<void> _run(Future<String> Function() action) async {
    try {
      final status = await action();
      if (mounted) setState(() => _status = status);
    } on WorkoutkitException catch (e) {
      if (mounted) setState(() => _status = '${e.code}: ${e.message}');
    }
  }

  String _formatPace(int seconds) =>
      '${seconds ~/ 60}:${(seconds % 60).toString().padLeft(2, '0')} /km';

  @override
  Widget build(BuildContext context) {
    final workout = _workout;
    final unchanged = workout.copyWith(displayName: 'Tempo Run') ==
        sampleTempoPaceRun.copyWith(displayName: 'Tempo Run');
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(workout.displayName,
            style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Text('Repeats: $_repeats'),
        Slider(
          value: _repeats.toDouble(),
          min: 1,
          max: 8,
          divisions: 7,
          onChanged: (v) => setState(() => _repeats = v.round()),
        ),
        Text('Pace: ${_formatPace(_fastestPaceSeconds)} – '
            '${_formatPace(_fastestPaceSeconds + 30)}'),
        Slider(
          value: _fastestPaceSeconds.toDouble(),
          min: 210,
          max: 420,
          divisions: 14,
          onChanged: (v) => setState(() => _fastestPaceSeconds = v.round()),
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(unchanged ? Icons.drag_handle : Icons.edit),
          title: Text(unchanged
              ? 'Same steps as the sample (==)'
              : 'Different from the sample (==)'),
        ),
        const SizedBox(height: 8),
        FilledButton.icon(
          icon: const Icon(Icons.watch),
          label: const Text('Preview with presentPreview'),
          onPressed: () => _run(() async {
            await WorkoutKit.presentPreview(workout);
            return 'Preview closed';
          }),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          icon: const Icon(Icons.swap_vert),
          label: const Text('Export & import'),
          onPressed: () => _run(() async {
            final data = await WorkoutKit.exportWorkout(workout);
            final imported = await WorkoutKit.importWorkout(data);
            // Pace alerts come back as speed alerts, so compare the rest.
            final sameShape = imported is CustomWorkout &&
                imported.displayName == workout.displayName &&
                imported.blocks.first.iterations == _repeats;
            return 'Exported ${data.length} bytes; imported '
                '${sameShape ? 'the same workout' : 'a different workout'}';
          }),
        ),
        if (_status != null) ...[
          const SizedBox(height: 16),
          Text(_status!),
        ],
      ],
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
