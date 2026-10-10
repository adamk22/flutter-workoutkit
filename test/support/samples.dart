import 'package:flutter_workoutkit/flutter_workoutkit.dart';

/// Every sample exported from `lib/src/samples`, by variable name.
/// `samples_golden_test.dart` fails when a sample is added but not listed.
final Map<String, Workout> allSamples = {
  'sampleSingleGoalTimedWorkout': sampleSingleGoalTimedWorkout,
  'sampleSingleGoalEnergyWorkout': sampleSingleGoalEnergyWorkout,
  'sampleSingleOpenWorkout': sampleSingleOpenWorkout,
  'sampleSingleGoalSwimmingWorkout': sampleSingleGoalSwimmingWorkout,
  'samplePacerMinutesWorkout': samplePacerMinutesWorkout,
  'samplePacerHoursWorkout': samplePacerHoursWorkout,
  'sampleSpeedCyclingWorkout': sampleSpeedCyclingWorkout,
  'sampleCustomWorkout': sampleCustomWorkout,
  'sample10kTrainingRun': sample10kTrainingRun,
  'sample21kmTrainingRun': sample21kmTrainingRun,
  'sampleTempoPaceRun': sampleTempoPaceRun,
  'samplePoolSwimIntervals': samplePoolSwimIntervals,
  'sampleSwimBikeRunWorkout': sampleSwimBikeRunWorkout,
};
