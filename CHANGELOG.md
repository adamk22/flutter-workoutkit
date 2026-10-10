# Changelog

## [0.1.0]

See the README's "Migrating from 0.0.x to 0.1.0" section.

### Breaking

- The minimum iOS version is now 17.0 in the podspec. Apps targeting older versions previously crashed with an unregistered platform view.
- `WorkoutAlert` is abstract, and `WorkoutAlert.fromJson` returns the concrete alert subclass.
- `IntervalBlock.type` is optional and deprecated. WorkoutKit never used it.
- Removed `WorkoutService`. It called a native method that didn't exist.
- `toJson()` omits null fields.
- `WorkoutPreviewButton` no longer shows the Apple logo. Use `sfSymbol` to add an icon.
- `PaceRangeAlert`/`PaceThresholdAlert` have a new API. They were not exported before.
- `sampleSingleGoalEnergyWorkout` now uses 500 kcal instead of 1000 small calories.
- Requires Flutter 3.27+. Tested with Flutter 3.47.7 (Dart 3.13).
- iOS sources moved from `ios/Classes` to `ios/flutter_workoutkit/Sources/flutter_workoutkit` for Swift Package Manager support.
- `WorkoutActivityType.dance` is deprecated (Apple deprecated `HKWorkoutActivityType.dance` in iOS 14) and is sent as `cardioDance`.

### Added

- Swift Package Manager support, which Flutter now uses by default. CocoaPods is still supported.
- `WorkoutActivityType.cardioDance` and `socialDance`.
- `WorkoutScheduler`: `isSupported`, `authorizationState`, `requestAuthorization`, `schedule`, `scheduledWorkouts`, `remove`, `markComplete`, `removeAll`, `maxAllowedScheduledWorkoutCount`, plus the `ScheduledWorkout` model.
- `Workoutkit.validate`, which runs WorkoutKit's `supportsActivity`, `supportsGoal`, `supportsAlert` and `supportsActivityOrdering` checks.
- `Workoutkit.exportWorkout` / `importWorkout`, using WorkoutKit's `dataRepresentation`.
- The `poolSwimDistanceWithTime` goal (iOS 18).
- Pace alerts (`PaceRangeAlert`, `PaceThresholdAlert`) with a `PaceUnit` (per km or per mile).
- Named `WorkoutGoal` constructors: `.open()`, `.distance()`, `.time()`, `.energy()` and `.poolSwimDistanceWithTime()`.
- `Workout.fromJson`, which returns the right subclass, and an optional `Workout.id`.
- `WorkoutkitException` and `WorkoutkitErrorCode` for native errors.
- `WorkoutPreviewButton.sfSymbol` and `WorkoutPreviewButton.onError`.
- New samples: `sampleTempoPaceRun` and `samplePoolSwimIntervals`.
- Tests:
  - Shared JSON contract fixtures checked by both Dart and Swift tests, plus method channel and widget tests, Swift XCTests, integration tests, and GitHub Actions CI.
  - Regression suites: 0.0.11 source and JSON compatibility, sample goldens, a 300-workout seeded random corpus that must never crash WorkoutKit, simulated iOS 17.0 fallbacks, and a fake scheduler.

### Fixed

- The app crashed when WorkoutKit was given an unsupported workout (WorkoutKit traps). Workouts are now checked before they are built, and failures come back as `UNSUPPORTED_WORKOUT`.
- The app crashed on any malformed or incomplete workout JSON (force unwraps and `fatalError`). These now throw `INVALID_ARGUMENT`.
- `CadenceRangeAlert` didn't send its bounds, which crashed the native side.
- `fromJson` round-trips were broken:
  - `WorkoutAlertType.fromString` and `UnitSpeed.fromString` never matched.
  - Lists were decoded as `List<dynamic>`.
  - Alerts lost their subclass and values.
  - Integer JSON numbers failed `as double` casts.
- Time goals and pacer durations were truncated by integer division, so 90 s shown in minutes became 1 minute.
- Unknown alert types silently became heart rate zone 1.
- The preview button leaked a hosting view controller into the root view controller for every button.
- The preview button didn't update when its workout or style changed.
- Speed alert metrics no longer require iOS 17.4.
- `dart:io` is no longer imported, so the package compiles for web.
- `Color.value` deprecation warnings.
- `pod lib lint` warnings: missing license type and missing source.

### Deprecated

- `Workoutkit.requestHealthPermissions` / `hasHealthPermissions`. WorkoutKit doesn't need HealthKit permissions.

## [0.0.11]

- BREAKING: Changed main import from `workoutkit.dart` to `flutter_workoutkit.dart`
- Added display string methods to all workout alert classes and enums

## [0.0.10]

- Added `toJson` and `fromJson` methods to all workout classes
- Added `iconData` property to `WorkoutActivityType` enum

## [0.0.9]

- Added `hasHealthPermissions` method to the Workoutkit class

## [0.0.8]

- Minor fixes

## [0.0.7]

## [0.0.6]

- Added basic customization options for `WorkoutPreviewButton` widget

## [0.0.5]

## [0.0.4]

- Minor fixes

## [0.0.3]

- Minor fixes

## [0.0.2]

- Minor fixes

## [0.0.1]

- Initial release of the Flutter WorkoutKit plugin.
