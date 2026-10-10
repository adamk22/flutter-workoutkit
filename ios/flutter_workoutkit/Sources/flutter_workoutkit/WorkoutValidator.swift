import HealthKit
import WorkoutKit

/// A problem that prevents WorkoutKit from accepting a workout.
struct ValidationIssue: Equatable, Sendable {
    /// Machine readable kind of problem; mirrors Dart's
    /// `WorkoutValidationIssueCode`.
    enum Code: String, Sendable {
        case unsupportedActivity
        case unsupportedGoal
        case unsupportedAlert
        case unsupportedActivityOrdering
        case missingBlocks
        case missingActivities
        case unsupportedOS
        case invalidWorkout
    }

    let code: Code
    /// Where in the workout JSON the problem is, e.g. `blocks[0].steps[1]`.
    let path: String?
    let message: String

    var dictionary: [String: Any] {
        var json: [String: Any] = ["code": code.rawValue, "message": message]
        if let path { json["path"] = path }
        return json
    }
}

/// Runs WorkoutKit's `supports…` checks.
///
/// WorkoutKit initializers trap on unsupported combinations (e.g. a pool swim
/// goal in a `SingleGoalWorkout`), so `WorkoutPlanBuilder` calls these checks
/// before constructing anything and throws `unsupportedWorkout` instead.
enum WorkoutValidator {
    /// Returns the issues for a Dart workout JSON; empty when the workout is
    /// supported.
    static func issues(for json: Any?) -> [ValidationIssue] {
        do {
            _ = try WorkoutPlanBuilder.plan(from: json)
            return []
        } catch let error as WorkoutkitError {
            return error.validationIssues
        } catch {
            return [ValidationIssue(code: .invalidWorkout, path: nil, message: "\(error)")]
        }
    }

    static func name(_ activity: HKWorkoutActivityType) -> String {
        WorkoutTypeConvert.name(of: activity, in: WorkoutTypeConvert.activityTypes) ?? "activity \(activity.rawValue)"
    }

    private static func unsupportedActivity(_ activity: HKWorkoutActivityType, _ kind: String) -> ValidationIssue {
        ValidationIssue(
            code: .unsupportedActivity,
            path: "activityType",
            message: "\(name(activity)) is not supported for \(kind) workouts"
        )
    }

    static func custom(
        activity: HKWorkoutActivityType,
        location: HKWorkoutSessionLocationType,
        steps: [(path: String, step: WorkoutStep)],
        blockCount: Int
    ) -> [ValidationIssue] {
        guard CustomWorkout.supportsActivity(activity) else {
            return [unsupportedActivity(activity, "custom")]
        }
        var issues: [ValidationIssue] = []
        if blockCount == 0 {
            issues.append(ValidationIssue(
                code: .missingBlocks, path: "blocks",
                message: "A custom workout needs at least one interval block"
            ))
        }
        for (path, step) in steps {
            if !CustomWorkout.supportsGoal(step.goal, activity: activity, location: location) {
                issues.append(ValidationIssue(
                    code: .unsupportedGoal, path: path,
                    message: "\(path): goal is not supported for \(name(activity))"
                ))
            }
            if let alert = step.alert,
               !CustomWorkout.supportsAlert(alert, activity: activity, location: location) {
                issues.append(ValidationIssue(
                    code: .unsupportedAlert, path: path,
                    message: "\(path): alert is not supported for \(name(activity))"
                ))
            }
        }
        return issues
    }

    static func singleGoal(
        activity: HKWorkoutActivityType,
        location: HKWorkoutSessionLocationType,
        goal: WorkoutGoal
    ) -> [ValidationIssue] {
        guard SingleGoalWorkout.supportsActivity(activity) else {
            return [unsupportedActivity(activity, "single goal")]
        }
        guard SingleGoalWorkout.supportsGoal(goal, activity: activity, location: location) else {
            return [ValidationIssue(
                code: .unsupportedGoal, path: "goal",
                message: "goal is not supported for \(name(activity)) single goal workouts"
            )]
        }
        return []
    }

    static func pacer(activity: HKWorkoutActivityType) -> [ValidationIssue] {
        PacerWorkout.supportsActivity(activity) ? [] : [unsupportedActivity(activity, "pacer")]
    }

    static func swimBikeRun(_ activities: [SwimBikeRunWorkout.Activity]) -> [ValidationIssue] {
        if activities.isEmpty {
            return [ValidationIssue(
                code: .missingActivities, path: "activities",
                message: "A swim bike run workout needs at least one activity"
            )]
        }
        return SwimBikeRunWorkout.supportsActivityOrdering(activities) ? [] : [ValidationIssue(
            code: .unsupportedActivityOrdering, path: "activities",
            message: "This activity ordering is not supported for swim bike run workouts"
        )]
    }

    /// Throws `unsupportedWorkout` when `issues` is not empty.
    static func require(_ issues: [ValidationIssue]) throws {
        if !issues.isEmpty { throw WorkoutkitError.unsupportedWorkout(issues) }
    }
}
