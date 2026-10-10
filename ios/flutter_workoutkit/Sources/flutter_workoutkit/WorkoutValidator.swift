import HealthKit
import WorkoutKit

/// Runs WorkoutKit's `supports…` checks.
///
/// WorkoutKit initializers trap on unsupported combinations (e.g. a pool swim
/// goal in a `SingleGoalWorkout`), so `WorkoutPlanBuilder` calls these checks
/// before constructing anything and throws `unsupportedWorkout` instead.
enum WorkoutValidator {
    /// Returns human readable issues for a Dart workout JSON; empty when the
    /// workout is supported.
    static func issues(for json: Any?) -> [String] {
        do {
            _ = try WorkoutPlanBuilder.plan(from: json)
            return []
        } catch let WorkoutkitError.unsupportedWorkout(issues) {
            return issues
        } catch {
            return ["\(error)"]
        }
    }

    static func name(_ activity: HKWorkoutActivityType) -> String {
        WorkoutTypeConvert.name(of: activity, in: WorkoutTypeConvert.activityTypes) ?? "activity \(activity.rawValue)"
    }

    static func custom(
        activity: HKWorkoutActivityType,
        location: HKWorkoutSessionLocationType,
        steps: [(path: String, step: WorkoutStep)],
        blockCount: Int
    ) -> [String] {
        guard CustomWorkout.supportsActivity(activity) else {
            return ["\(name(activity)) is not supported for custom workouts"]
        }
        var issues: [String] = []
        if blockCount == 0 { issues.append("A custom workout needs at least one interval block") }
        for (path, step) in steps {
            if !CustomWorkout.supportsGoal(step.goal, activity: activity, location: location) {
                issues.append("\(path): goal is not supported for \(name(activity))")
            }
            if let alert = step.alert,
               !CustomWorkout.supportsAlert(alert, activity: activity, location: location) {
                issues.append("\(path): alert is not supported for \(name(activity))")
            }
        }
        return issues
    }

    static func singleGoal(
        activity: HKWorkoutActivityType,
        location: HKWorkoutSessionLocationType,
        goal: WorkoutGoal
    ) -> [String] {
        guard SingleGoalWorkout.supportsActivity(activity) else {
            return ["\(name(activity)) is not supported for single goal workouts"]
        }
        guard SingleGoalWorkout.supportsGoal(goal, activity: activity, location: location) else {
            return ["goal is not supported for \(name(activity)) single goal workouts"]
        }
        return []
    }

    static func pacer(activity: HKWorkoutActivityType) -> [String] {
        PacerWorkout.supportsActivity(activity) ? [] : ["\(name(activity)) is not supported for pacer workouts"]
    }

    static func swimBikeRun(_ activities: [SwimBikeRunWorkout.Activity]) -> [String] {
        if activities.isEmpty { return ["A swim bike run workout needs at least one activity"] }
        return SwimBikeRunWorkout.supportsActivityOrdering(activities)
            ? [] : ["This activity ordering is not supported for swim bike run workouts"]
    }

    /// Throws `unsupportedWorkout` when `issues` is not empty.
    static func require(_ issues: [String]) throws {
        if !issues.isEmpty { throw WorkoutkitError.unsupportedWorkout(issues) }
    }
}
