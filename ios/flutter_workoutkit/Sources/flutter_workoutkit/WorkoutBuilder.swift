import HealthKit
import WorkoutKit

/// Builds WorkoutKit steps, goals and alerts from the Dart JSON contract
/// (see `test/fixtures` in the repository).
enum WorkoutBuilder {
    static func intervalBlocks(_ readers: [JSONReader]) throws -> [IntervalBlock] {
        try readers.map { block in
            let iterations = try block.int("iterations")
            guard iterations >= 1 else {
                throw WorkoutkitError.invalidArgument(path: "\(block.path).iterations", expected: "integer >= 1")
            }
            return IntervalBlock(steps: try intervalSteps(block.objects("steps")), iterations: iterations)
        }
    }

    static func intervalSteps(_ readers: [JSONReader]) throws -> [IntervalStep] {
        try readers.map { json in
            let purpose: IntervalStep.Purpose = try json.enumValue("purpose", ["work": .work, "recovery": .recovery])
            var intervalStep: IntervalStep
            if let stepJson = try json.optionalObject("step") {
                intervalStep = IntervalStep(purpose, step: try workoutStep(stepJson))
            } else if let goalJson = try json.optionalObject("goal") {
                intervalStep = IntervalStep(purpose, goal: try workoutGoal(goalJson))
            } else {
                throw WorkoutkitError.invalidArgument(path: json.path, expected: "either 'goal' or 'step'")
            }
            if let alertJson = try json.optionalObject("alert") {
                intervalStep.step.alert = try workoutAlert(alertJson)
            }
            return intervalStep
        }
    }

    static func workoutStep(_ json: JSONReader) throws -> WorkoutStep {
        var step = WorkoutStep(goal: try workoutGoal(json.object("goal")))
        if let alertJson = try json.optionalObject("alert") {
            step.alert = try workoutAlert(alertJson)
        }
        // Step names are an iOS 18 feature; older versions just omit them.
        if PlatformFeatures.current.stepDisplayName, #available(iOS 18.0, *),
           let displayName = try json.optionalString("displayName") {
            step.displayName = displayName
        }
        return step
    }

    static func workoutGoal(_ json: JSONReader) throws -> WorkoutGoal {
        switch try json.string("type") {
        case "open":
            return .open
        case "distance":
            return .distance(try json.double("targetValue"), try json.enumValue("unit", WorkoutTypeConvert.lengthUnits))
        case "energy":
            return .energy(try json.double("targetValue"), try json.enumValue("unit", WorkoutTypeConvert.energyUnits))
        case "time":
            let unit = try json.optionalEnumValue("unit", WorkoutTypeConvert.durationUnits) ?? .minutes
            return .time(try duration(json.double("targetDuration"), in: unit).value, unit)
        case "poolSwimDistanceWithTime":
            guard PlatformFeatures.current.poolSwimGoal, #available(iOS 18.0, *) else {
                throw WorkoutkitError.unsupportedOS(
                    feature: "Pool swim distance with time goals",
                    minimum: "18.0",
                    path: WorkoutkitError.relative(json.path)
                )
            }
            let distance = Measurement(
                value: try json.double("targetValue"),
                unit: try json.enumValue("unit", WorkoutTypeConvert.lengthUnits)
            )
            let durationUnit = try json.optionalEnumValue("durationUnit", WorkoutTypeConvert.durationUnits) ?? .minutes
            return .poolSwimDistanceWithTime(distance, try duration(json.double("targetDuration"), in: durationUnit))
        default:
            throw WorkoutkitError.invalidArgument(
                path: "\(json.path).type",
                expected: "one of open, distance, time, energy, poolSwimDistanceWithTime"
            )
        }
    }

    /// Dart sends durations in seconds; WorkoutKit shows them in `unit`.
    static func duration(_ seconds: Double, in unit: UnitDuration) -> Measurement<UnitDuration> {
        Measurement(value: seconds, unit: UnitDuration.seconds).converted(to: unit)
    }

    static func workoutAlert(_ json: JSONReader) throws -> any WorkoutAlert {
        switch try json.string("type") {
        case "heartRateZone":
            return .heartRate(zone: try json.int("zone"))
        case "heartRateRange":
            return .heartRate(try range(json))
        case "cadenceRange":
            return .cadence(try range(json))
        case "cadenceThreshold":
            return .cadence(try json.double("threshold"))
        case "powerZone":
            return .power(zone: try json.int("zone"))
        case "powerRange":
            let bounds = try range(json)
            let metric = try json.optionalEnumValue("metric", WorkoutTypeConvert.alertMetrics) ?? .current
            if PlatformFeatures.current.powerAlertMetric, #available(iOS 17.4, *) {
                return .power(bounds, unit: .watts, metric: metric)
            }
            return .power(bounds, unit: .watts)
        case "powerThreshold":
            let threshold = try json.double("threshold")
            let metric = try json.optionalEnumValue("metric", WorkoutTypeConvert.alertMetrics) ?? .current
            if PlatformFeatures.current.powerAlertMetric, #available(iOS 17.4, *) {
                return .power(threshold, unit: .watts, metric: metric)
            }
            return .power(threshold, unit: .watts)
        // Pace alerts arrive with precomputed speed fields (see PaceRangeAlert in Dart).
        case "speedRange", "paceRange":
            return .speed(
                try range(json),
                unit: try json.enumValue("unitSpeed", WorkoutTypeConvert.speedUnits),
                metric: try json.optionalEnumValue("metric", WorkoutTypeConvert.alertMetrics) ?? .current
            )
        case "speedThreshold", "paceThreshold":
            return .speed(
                try json.double("threshold"),
                unit: try json.enumValue("unitSpeed", WorkoutTypeConvert.speedUnits),
                metric: try json.optionalEnumValue("metric", WorkoutTypeConvert.alertMetrics) ?? .current
            )
        default:
            throw WorkoutkitError.invalidArgument(path: "\(json.path).type", expected: "a known alert type")
        }
    }

    private static func range(_ json: JSONReader) throws -> ClosedRange<Double> {
        let lower = try json.double("lowerBound")
        let upper = try json.double("upperBound")
        guard lower <= upper else {
            throw WorkoutkitError.invalidArgument(path: "\(json.path).lowerBound", expected: "a value <= upperBound")
        }
        return lower...upper
    }

    static func swimBikeRunActivities(_ readers: [JSONReader]) throws -> [SwimBikeRunWorkout.Activity] {
        try readers.map { json in
            switch try json.string("type") {
            case "swimming":
                return .swimming(try json.enumValue("swimmingLocation", WorkoutTypeConvert.swimmingLocations))
            case "cycling":
                return .cycling(try json.enumValue("location", WorkoutTypeConvert.locations))
            case "running":
                return .running(try json.enumValue("location", WorkoutTypeConvert.locations))
            default:
                throw WorkoutkitError.invalidArgument(path: "\(json.path).type", expected: "one of swimming, cycling, running")
            }
        }
    }
}
