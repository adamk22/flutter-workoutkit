# Contributing

Contributions of all kinds are greatly appreciated. To help smoothen the process we have a few non-exhaustive guidelines to follow which should get you going in no time.

## Using GitHub Issues

- Feel free to use GitHub issues for questions, bug reports, and feature requests
- Use the search feature to check for an existing issue
- Include as much information as possible and provide any relevant resources (Eg. screenshots)
- For bug reports ensure you have a reproducible test case
  - A pull request with a breaking test would be super preferable here but isn't required

## Getting Started

- Fork the repository
- Send your commits
- Submit a Pull request

## Submitting a Pull Request

- Write appropriate title
- Write a proper description including the issue name and solution

## Development setup

You need Flutter 3.27+ (CI uses the latest stable), Xcode 16+ and [just](https://github.com/casey/just) (optional).

> **Clone into a directory named `flutter_workoutkit`.** Flutter uses Swift Package Manager by default. For a plugin's example app, Flutter adds the plugin package as a local override. Swift Package Manager rejects that override when the checkout directory name differs from the plugin name, and fails with "unable to override package 'flutter_workoutkit' because its identity … doesn't match". The default GitHub clone name (`flutter-workoutkit`) triggers this:
>
> ```bash
> git clone https://github.com/adamk22/flutter-workoutkit.git flutter_workoutkit
> ```
>
> This only affects developing the plugin. Apps that depend on it are not affected.

```bash
just check            # format check, analyzer, Dart tests and Swift tests
just test             # Dart tests only (plugin + example)
just test-ios         # Swift XCTests (example/ios/RunnerTests) on a simulator
just test-integration # integration tests on a booted simulator or device
```

Without `just`, run the commands in [.justfile](.justfile) directly.

## How the plugin is structured

The iOS code lives in `ios/flutter_workoutkit/Sources/flutter_workoutkit` and is built with Swift Package Manager (`ios/flutter_workoutkit/Package.swift`) or CocoaPods (`ios/flutter_workoutkit.podspec`). Both must keep working; see [Verifying both iOS build systems](#verifying-both-ios-build-systems).


- **Dart models** (`lib/src/classes`) serialize workouts to JSON with `toJson()`.
- **Swift builders** (`ios/flutter_workoutkit/Sources/flutter_workoutkit/WorkoutPlanBuilder.swift`, `WorkoutBuilder.swift`) turn that JSON into a WorkoutKit `WorkoutPlan`. They throw a `WorkoutkitError` instead of crashing.
- **`WorkoutValidator.swift`** runs WorkoutKit's `supports…` checks before anything is constructed, because WorkoutKit traps on unsupported combinations.
- **`WorkoutPlanSerializer.swift`** turns a `WorkoutPlan` back into the same JSON, for scheduled and imported workouts.
- **`WorkoutPreview/WorkoutPreviewPresenter.swift`** backs `WorkoutKit.presentPreview`: it presents a transparent hosting controller whose SwiftUI view opens Apple's sheet.
- **Concurrency:** the native code builds with complete strict-concurrency checking. Keep it warning-free. UIKit work goes through `MainActor.assumeIsolated` (Flutter calls in on the main thread), and Flutter callbacks cross into `@MainActor` tasks via `UncheckedSendable`.
- **Simulating older iOS versions:** `PlatformFeatures.current` is `@TaskLocal`. Wrap test code in `onIOS17_0 { ... }` (see `example/ios/RunnerTests/Fixtures.swift`) instead of mutating global state.

### The JSON contract

`test/fixtures/*.json` is the contract between Dart and Swift:

- `test/models/fixtures_test.dart` checks that the Dart models produce exactly these files and parse them back.
- `example/ios/RunnerTests/WorkoutPlanBuilderTests.swift` builds WorkoutKit plans from the same files and compares them with hand-built plans.
- `WorkoutPlanSerializerTests.swift` checks that serializing those plans gives back the same files.

When you add or change a serialized field, update the fixture, the Dart model, the Swift builder and serializer, and both test suites in the same pull request. If you add Swift test files, add them to the `RunnerTests` target in `example/ios/Runner.xcodeproj`.

### Regression tests

- **`test/compat/`** compiles the 0.0.11 sample code verbatim against the current API. It checks that this code produces the same JSON as 0.0.11, that JSON saved by 0.0.11 still loads, and that every 0.0.11 enum value still exists.
- **Goldens:** `samples.json` and `random_workouts.json` fail the build when serialization changes. If a change is intentional, run `UPDATE_GOLDENS=true flutter test` and review the diff.
- **Swift `RegressionTests`:** builds the legacy JSON, the samples and the random corpus natively. It also simulates iOS 17.0 via `PlatformFeatures.current`, so the fallbacks are tested on newer simulators.
- **Swift `SchedulerTests`:** drives the scheduler method handler with a `FakeScheduler`. The real `WorkoutScheduler` needs user authorization.

When you fix a bug, add a test that fails without the fix. These suites were checked by reintroducing the original 0.0.11 bugs one at a time. Each one makes the suites fail.

### CI

GitHub Actions runs the Dart checks on Linux and the Swift tests on iOS 17.5, 18.6 and the latest simulator runtime. A missing runtime is downloaded with `xcodebuild -downloadPlatform`. The iOS 17.5 and 18.6 jobs use Xcode 16 on `macos-15`, because Xcode 26 doesn't offer those simulators as test destinations. The latest job uses the newest stable Xcode. The iOS 17.5 job runs the real-OS versions of the fallbacks that `onIOS17_0` simulates locally. Integration tests and `pod lib lint` run on the latest runtime only.

### Manual checks that need a device

Scheduling only reaches a real Watch when a paired Apple Watch is present:

1. Run the example app on an iPhone paired with an Apple Watch.
2. On the **Schedule** tab, request authorization, then schedule the sample.
3. Check that it appears in the Workout app on the Watch.
4. Mark it complete, then remove it.
5. On the **Preview** tab, open a few previews and add one to the Watch.

### Verifying both iOS build systems

The example app uses Swift Package Manager; `just test-ios` and the integration tests cover that path. To check CocoaPods:

```bash
pod lib lint ios/flutter_workoutkit.podspec --configuration=Debug --skip-tests --use-modular-headers --use-libraries
```

For a full CocoaPods build, create a throwaway app with `flutter create`. Add `config: enable-swift-package-manager: false` under `flutter:` in its `pubspec.yaml`, add this plugin as a path dependency, set its deployment target to 17.0, and build it. Don't switch the example app itself: once it has been migrated to Swift Package Manager it can't go back to CocoaPods.
