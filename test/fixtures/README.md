# JSON contract fixtures

These files are the contract between the Dart models (`toJson`/`fromJson`)
and the Swift builders (`ios/flutter_workoutkit/Sources/flutter_workoutkit/WorkoutPlanBuilder.swift`). They are
read by both test suites:

- Dart: `test/models/fixtures_test.dart` checks that `toJson()` produces each
  fixture exactly and that `fromJson` round-trips it.
- Swift: `example/ios/RunnerTests/WorkoutPlanBuilderTests.swift` builds a
  WorkoutKit `WorkoutPlan` from each fixture and compares it with a
  hand-built plan.

When you add or change a serialized field, update the fixture and both test
suites in the same change.

## Other fixtures

| File | Produced by | Regenerate? |
|---|---|---|
| `samples.json` | Every exported sample's `toJson()` (`test/models/samples_golden_test.dart`) | Yes: `UPDATE_GOLDENS=true flutter test` after an intentional change |
| `random_workouts.json` | ~300 seeded random workouts from `test/support/random_workouts.dart`, many of them unsupported by WorkoutKit | Yes, same command |
| `legacy_0.0.11/*.json` | The 0.0.11 release (commit 2ad49c4), captured once | **Never.** It is the backwards-compatibility baseline |

The Swift `RegressionTests` read all of these files:

- Workouts serialized by 0.0.11 must still build.
- Every sample must build, validate and round-trip.
- Every random workout must either build and round-trip, or be rejected with `UNSUPPORTED_WORKOUT`/`UNSUPPORTED_OS`. It must never crash, since WorkoutKit traps on unsupported workouts.
