import HealthKit
import WorkoutKit

/// Builds a `WorkoutPlan` from a Dart `Workout.toJson()` map.
///
/// Every workout is checked with WorkoutKit's `supports…` APIs first, because
/// WorkoutKit traps on unsupported combinations instead of throwing.
enum WorkoutPlanBuilder {
    static func plan(from value: Any?) throws -> WorkoutPlan {
        try plan(JSONReader(any: value))
    }

    static func plan(_ json: JSONReader) throws -> WorkoutPlan {
        let workout: WorkoutPlan.Workout
        switch try json.string("workoutType") {
        case "customWorkout": workout = .custom(try customWorkout(json))
        case "singleGoalWorkout": workout = .goal(try singleGoalWorkout(json))
        case "pacerWorkout": workout = .pacer(try pacerWorkout(json))
        case "swimBikeRunWorkout": workout = .swimBikeRun(try swimBikeRunWorkout(json))
        default:
            throw WorkoutkitError.invalidArgument(
                path: "\(json.path).workoutType",
                expected: "one of customWorkout, singleGoalWorkout, pacerWorkout, swimBikeRunWorkout"
            )
        }

        guard let idString = try json.optionalString("id") else {
            return WorkoutPlan(workout)
        }
        guard let id = UUID(uuidString: idString) else {
            throw WorkoutkitError.invalidArgument(path: "\(json.path).id", expected: "UUID string")
        }
        return WorkoutPlan(workout, id: id)
    }

    private static func activity(_ json: JSONReader) throws -> HKWorkoutActivityType {
        try json.enumValue("activityType", WorkoutTypeConvert.activityTypesForDecoding)
    }

    private static func location(_ json: JSONReader) throws -> HKWorkoutSessionLocationType {
        try json.optionalEnumValue("location", WorkoutTypeConvert.locations) ?? .unknown
    }

    static func customWorkout(_ json: JSONReader) throws -> CustomWorkout {
        let activity = try activity(json)
        let location = try location(json)
        let warmup = try json.optionalObject("warmup").map(WorkoutBuilder.workoutStep)
        let blocks = try WorkoutBuilder.intervalBlocks(json.objects("blocks"))
        let cooldown = try json.optionalObject("cooldown").map(WorkoutBuilder.workoutStep)

        var steps: [(path: String, step: WorkoutStep)] = []
        if let warmup { steps.append(("warmup", warmup)) }
        for (b, block) in blocks.enumerated() {
            for (s, step) in block.steps.enumerated() {
                steps.append(("blocks[\(b)].steps[\(s)]", step.step))
            }
        }
        if let cooldown { steps.append(("cooldown", cooldown)) }
        try WorkoutValidator.require(
            WorkoutValidator.custom(activity: activity, location: location, steps: steps, blockCount: blocks.count)
        )

        return CustomWorkout(
            activity: activity,
            location: location,
            displayName: try json.optionalString("displayName"),
            warmup: warmup,
            blocks: blocks,
            cooldown: cooldown
        )
    }

    static func singleGoalWorkout(_ json: JSONReader) throws -> SingleGoalWorkout {
        let activity = try activity(json)
        let goal = try WorkoutBuilder.workoutGoal(json.object("goal"))
        if activity == .swimming {
            let swimmingLocation = try json.enumValue("swimmingLocation", WorkoutTypeConvert.swimmingLocations)
            try WorkoutValidator.require(WorkoutValidator.singleGoal(activity: activity, location: .unknown, goal: goal))
            return SingleGoalWorkout(activity: activity, swimmingLocation: swimmingLocation, goal: goal)
        }
        let location = try location(json)
        try WorkoutValidator.require(WorkoutValidator.singleGoal(activity: activity, location: location, goal: goal))
        return SingleGoalWorkout(activity: activity, location: location, goal: goal)
    }

    static func pacerWorkout(_ json: JSONReader) throws -> PacerWorkout {
        let activity = try activity(json)
        let location = try location(json)
        let distance = Measurement(
            value: try json.double("targetValue"),
            unit: try json.enumValue("targetValueUnit", WorkoutTypeConvert.lengthUnits)
        )
        let time = WorkoutBuilder.duration(
            try json.double("targetDuration"),
            in: try json.enumValue("targetDurationUnit", WorkoutTypeConvert.durationUnits)
        )
        try WorkoutValidator.require(WorkoutValidator.pacer(activity: activity))
        return PacerWorkout(activity: activity, location: location, distance: distance, time: time)
    }

    static func swimBikeRunWorkout(_ json: JSONReader) throws -> SwimBikeRunWorkout {
        let activities = try WorkoutBuilder.swimBikeRunActivities(json.objects("activities"))
        try WorkoutValidator.require(WorkoutValidator.swimBikeRun(activities))
        return SwimBikeRunWorkout(activities: activities, displayName: try json.optionalString("displayName"))
    }
}
