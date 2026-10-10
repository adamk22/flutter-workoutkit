# flutter_workoutkit

[![pub points](https://img.shields.io/pub/points/flutter_workoutkit?color=2E8B57&label=pub%20points)](https://pub.dev/packages/flutter_workoutkit/score)
[![pub package](https://img.shields.io/pub/v/flutter_workoutkit.svg)](https://pub.dev/packages/flutter_workoutkit)
[![platform](https://img.shields.io/badge/platform-ios-blue.svg)](https://pub.dev/packages/flutter_workoutkit)
[![License: MIT](https://img.shields.io/badge/license-Apache%202.0-blue?style=flat-square)](https://opensource.org/licenses/Apache-2.0)

A Flutter plugin for Apple's [WorkoutKit](https://developer.apple.com/documentation/workoutkit). Use it to build custom workouts in Dart, then preview, validate, export and schedule them for the Workout app on Apple Watch.

> **Requirements:** iOS 17.0+ and an Apple Watch paired with the iPhone to actually run workouts. Pool swim goals and step names need iOS 18.0+. Android is not supported: the widgets render nothing and the API calls throw.

## 🚨 Active Development!

This plugin is under active development, and breaking changes may land before 1.0.0. See the [CHANGELOG](CHANGELOG.md) and the [migration guide](#-migrating-from-00x-to-010). Please report issues and feature requests on [GitHub](https://github.com/adamk22/flutter-workoutkit).

## 🔑 Key Features

- **Four workout types:** custom interval workouts, single goal, pacer and swim-bike-run.
- **Goals:** distance, time, energy, open, and pool swim distance-within-time.
- **Alerts:** heart rate, cadence, power, speed and pace.
- **Preview** a workout in Apple's native sheet, from which the user adds it to their Watch.
- **Schedule** workouts directly onto the Watch with `WorkoutScheduler`.
- **Validate** a workout against WorkoutKit's own rules before showing it.
- **Export and import** workouts in WorkoutKit's binary format.

## 🎥 Preview

<div style="display: flex; justify-content: space-between;">
    <img src="https://adamkramer.nl/workoutkit/demo.gif" width="100%" alt="Demo 1">
</div>

## 📸 Screenshots

<div style="display: flex; justify-content: space-between;">
    <img src="https://adamkramer.nl/workoutkit/1.png" style="width: 48%;" width="48%" alt="Screenshot 1">
    <img src="https://adamkramer.nl/workoutkit/2.png" style="width: 48%;" width="48%" alt="Screenshot 2">
</div>

## 📥 Installation

```yaml
dependencies:
  flutter_workoutkit: ^0.1.0
```

Set your iOS deployment target to **17.0** or higher in Xcode (Runner target → Minimum Deployments). If your app still uses CocoaPods, set it in `ios/Podfile` too:

```ruby
platform :ios, '17.0'
```

The plugin supports Swift Package Manager, which Flutter uses by default, and CocoaPods.

You don't need a HealthKit entitlement or HealthKit usage descriptions for previewing or scheduling. You only need them if you still call the deprecated `Workoutkit.requestHealthPermissions`.

## 🚀 Quick start

```dart
import 'package:flutter_workoutkit/flutter_workoutkit.dart';

final tempoRun = CustomWorkout(
  activityType: WorkoutActivityType.running,
  location: WorkoutLocationType.outdoor,
  displayName: 'Tempo Run',
  warmup: WorkoutStep(
    goal: const WorkoutGoal.time(Duration(minutes: 10)),
    alert: HeartRateZoneAlert(zone: 2),
  ),
  blocks: [
    IntervalBlock(iterations: 3, steps: [
      IntervalStep(
        purpose: IntervalStepPurpose.work,
        goal: const WorkoutGoal.distance(2, WorkoutGoalUnit.kilometers),
        alert: PaceRangeAlert(
          fastestPace: const Duration(minutes: 5),
          slowestPace: const Duration(minutes: 5, seconds: 30),
        ),
      ),
      IntervalStep(
        purpose: IntervalStepPurpose.recovery,
        goal: const WorkoutGoal.time(Duration(seconds: 90),
            unit: WorkoutGoalUnit.seconds),
      ),
    ]),
  ],
  cooldown: WorkoutStep(goal: const WorkoutGoal.time(Duration(minutes: 5))),
);

// 1. Let the user preview the workout and add it to their Watch:
WorkoutPreviewButton(workout: tempoRun);

// 2. Or schedule it directly:
if (await WorkoutScheduler.requestAuthorization() ==
    SchedulerAuthorizationState.authorized) {
  await WorkoutScheduler.schedule(tempoRun, DateTime(2026, 10, 12, 7, 0));
}
```

There are more workouts in [`lib/src/samples`](lib/src/samples) and in the [example app](example/lib/main.dart).

## 🏋️ Workouts

| Class | Description |
|---|---|
| `CustomWorkout` | An optional warmup, then `IntervalBlock`s of work/recovery `IntervalStep`s repeated `iterations` times, then an optional cooldown. |
| `SingleGoalWorkout` | One goal for the whole workout. Swimming takes a `swimmingLocation`; every other activity takes a `location`. |
| `PacerWorkout` | Cover a distance in a target time. |
| `SwimBikeRunWorkout` | Ordered multisport legs (`MultisportActivity`). |

Not every activity supports every workout type, goal or alert; for example, a pacer workout only supports a few activities. Check up front with [`Workoutkit.validate`](#-validation).

**Pool swimming:** use a `CustomWorkout` with `activityType: swimming` and `location: indoor`. WorkoutKit does not accept pool swim goals in a `SingleGoalWorkout`.

## 🎯 Goals

| Constructor | Available on |
|---|---|
| `WorkoutGoal.open()` | iOS 17 |
| `WorkoutGoal.distance(5, WorkoutGoalUnit.kilometers)` (meters, kilometers, miles, yards) | iOS 17 |
| `WorkoutGoal.time(Duration(minutes: 30), unit: WorkoutGoalUnit.minutes)` | iOS 17 |
| `WorkoutGoal.energy(400)` (kilocalories by default) | iOS 17 |
| `WorkoutGoal.poolSwimDistanceWithTime(distance: 100, distanceUnit: WorkoutGoalUnit.meters, duration: Duration(minutes: 2))` | **iOS 18** |

Durations are sent exactly; `unit` only controls how the Watch displays them.

`WorkoutGoalUnit.calories` are *small* calories (1000 cal = 1 kcal). Most apps mean `kilocalories`.

## 🔔 Alerts

| Alert | Notes |
|---|---|
| `HeartRateZoneAlert(zone: 1–5)` | Uses the zones configured in the Workout app. |
| `HeartRateRangeAlert(lowerBound:, upperBound:)` | Beats per minute. |
| `CadenceRangeAlert` / `CadenceThresholdAlert` | Steps or revolutions per minute. |
| `PowerZoneAlert` / `PowerRangeAlert` / `PowerThresholdAlert` | Watts. The `average` metric needs iOS 17.4+. |
| `SpeedRangeAlert` / `SpeedThresholdAlert` | m/s, km/h, mph or knots, using the current or average speed. |
| `PaceRangeAlert(fastestPace:, slowestPace:)` / `PaceThresholdAlert(pace:)` | Time per km or per mile. |

WorkoutKit has no separate pace alert. Pace alerts are sent to the Watch as speed alerts, and the Watch shows them as pace. A workout read back from WorkoutKit (from the scheduler or `importWorkout`) therefore returns them as `SpeedRangeAlert`/`SpeedThresholdAlert` in m/s.

`WorkoutStep(displayName: ...)` names a step on the Watch on iOS 18+. On iOS 17 the name is ignored.

## 👀 Previewing workouts

WorkoutKit only presents its preview sheet from a native SwiftUI view. `WorkoutPreviewButton` embeds a native button that opens that sheet:

```dart
WorkoutPreviewButton(
  workout: tempoRun,
  buttonTitle: 'Add to Apple Watch',
  sfSymbol: 'applewatch',          // optional, no icon by default
  backgroundColor: Colors.black,
  foregroundColor: Colors.white,
  cornerRadiusSize: 10,
  buttonHeight: 54,
  fontSize: 16,
  fontWeight: FontWeight.w600,
  onError: (WorkoutkitException e) => debugPrint('${e.code}: ${e.message}'),
)
```

If the workout can't be built (for example, it's unsupported, or it uses a pool swim goal on iOS 17), the button renders empty and calls `onError`. Changing `workout` or any styling recreates the native view.

## ⌚ Scheduling to Apple Watch

```dart
if (!await WorkoutScheduler.isSupported()) return;

final state = await WorkoutScheduler.requestAuthorization(); // asks once
if (state != SchedulerAuthorizationState.authorized) return;

final scheduled = await WorkoutScheduler.schedule(tempoRun, DateTime(2026, 10, 12, 7, 0));
final all = await WorkoutScheduler.scheduledWorkouts();
await WorkoutScheduler.markComplete(scheduled);
await WorkoutScheduler.remove(scheduled);
await WorkoutScheduler.removeAll();
final max = await WorkoutScheduler.maxAllowedScheduledWorkoutCount();
```

Dates are local time with minute precision. Each scheduled workout has a plan `id` (a UUID). You can set your own `id` on any workout, or let WorkoutKit generate one.

## ✅ Validation

WorkoutKit **crashes the app** when it is given an unsupported combination, such as an activity a pacer workout doesn't support or a goal that isn't valid for the activity. The plugin runs WorkoutKit's `supports…` checks before building every workout and turns failures into errors. You can also run the checks yourself:

```dart
final result = await Workoutkit.validate(workout);
if (!result.isValid) print(result.issues); // e.g. ["archery is not supported for pacer workouts"]
```

## 📦 Export / import

```dart
final Uint8List data = await Workoutkit.exportWorkout(workout); // WorkoutKit's dataRepresentation
final Workout copy = await Workoutkit.importWorkout(data);
```

## ⚠️ Error handling

Native failures are thrown as `WorkoutkitException`, which has a `code`, a `message` and, for some codes, `details`:

| `code` | Meaning |
|---|---|
| `INVALID_ARGUMENT` | The workout JSON was malformed (a bug: please report it). |
| `UNSUPPORTED_WORKOUT` | WorkoutKit doesn't support this activity/goal/alert combination. `details` lists the issues. |
| `UNSUPPORTED_OS` | The feature needs a newer iOS version. |
| `NOT_FOUND` | No scheduled workout matched the given id and date. |
| `SERIALIZATION_ERROR` | Export or import failed. |

## 🔁 Migrating from 0.0.x to 0.1.0

- **iOS 17.0 is now the minimum.** The podspec requires it, so CocoaPods rejects apps that target an older version. Previously the button crashed on iOS 16.
- **HealthKit is no longer required.** `Workoutkit.requestHealthPermissions` and `hasHealthPermissions` are deprecated. Use `WorkoutScheduler.requestAuthorization` instead, and remove the HealthKit capability if nothing else in your app uses it.
- **`IntervalBlock.type` is deprecated and optional.** WorkoutKit never used it; set `IntervalStep.purpose` instead.
- **`WorkoutAlert` is now abstract.** `WorkoutAlert.fromJson` returns the concrete subclass.
- **`WorkoutService` was removed.** It called a native method that never existed.
- **`WorkoutActivityType.dance` is deprecated.** Use `cardioDance` or `socialDance`.
- **`toJson()` omits null fields.**
- **`sampleSingleGoalEnergyWorkout` now uses 500 kilocalories** instead of 1000 small calories.
- **The `WorkoutPreviewButton` no longer shows the Apple logo by default.** Pass `sfSymbol` to show an icon.
- **The `PaceRangeAlert`/`PaceThresholdAlert` API changed.** It was never exported before.

## 🧪 Development

See [CONTRIBUTING.md](CONTRIBUTING.md). Running `just check` runs the analyzer, the Dart tests and the Swift tests.

## 🚧 Roadmap

- ✅ `WorkoutPreviewButton` for previewing workouts, with customization
- ✅ `WorkoutScheduler` and scheduled workout plans
- ✅ `poolSwimDistanceWithTime` goals
- ✅ Pace alerts
- ✅ Validation, export and import
- ✅ Graceful errors instead of native crashes
- ✅ Tests (Dart, Swift and integration)
- ✅ Swift Package Manager support (CocoaPods still works)
- ❌ (Long term) Explore options for supporting Android

## 📝 License

This project is licensed under the Apache License 2.0. See the [LICENSE](LICENSE) file for details.

## 📧 Contact

For questions or feedback, please contact me at a@adamkramer.dev

## 💰 Buy me a coffee

If you find this plugin useful, please consider buying me a coffee:

<a href="https://buymeacoffee.com/admkrmr"><img style="width: 200px; border-radius: 10px;" src="https://adamkramer.nl/workoutkit/coffee.png" /></a>
