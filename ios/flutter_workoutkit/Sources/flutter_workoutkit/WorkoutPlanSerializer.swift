import HealthKit
import WorkoutKit

/// Converts a `WorkoutPlan` back into the Dart JSON contract, e.g. for
/// `WorkoutScheduler.scheduledWorkouts` and `Workoutkit.importWorkout`.
///
/// Pace alerts can't be told apart from speed alerts once inside WorkoutKit,
/// so they come back as speed alerts.
enum WorkoutPlanSerializer {
    static func json(_ plan: WorkoutPlan) throws -> [String: Any] {
        var json: [String: Any]
        switch plan.workout {
        case let .custom(workout): json = try custom(workout)
        case let .goal(workout): json = try singleGoal(workout)
        case let .pacer(workout): json = try pacer(workout)
        case let .swimBikeRun(workout): json = try swimBikeRun(workout)
        @unknown default:
            throw WorkoutkitError.serialization("Unsupported workout kind: \(plan.workout)")
        }
        json["id"] = plan.id.uuidString
        return json
    }

    // MARK: Workouts

    private static func activityName(_ activity: HKWorkoutActivityType) throws -> String {
        guard let name = WorkoutTypeConvert.name(of: activity, in: WorkoutTypeConvert.activityTypes) else {
            throw WorkoutkitError.serialization("Unsupported activity type: \(activity.rawValue)")
        }
        return name
    }

    private static func locationName(_ location: HKWorkoutSessionLocationType) -> String {
        WorkoutTypeConvert.name(of: location, in: WorkoutTypeConvert.locations) ?? "unknown"
    }

    private static func swimmingLocationName(_ location: HKWorkoutSwimmingLocationType) -> String {
        WorkoutTypeConvert.name(of: location, in: WorkoutTypeConvert.swimmingLocations) ?? "unknown"
    }

    static func custom(_ workout: CustomWorkout) throws -> [String: Any] {
        var json: [String: Any] = [
            "workoutType": "customWorkout",
            "activityType": try activityName(workout.activity),
            "location": locationName(workout.location),
            "displayName": workout.displayName ?? "",
            "blocks": try workout.blocks.map { block in
                ["iterations": block.iterations, "steps": try block.steps.map(intervalStep)] as [String: Any]
            },
        ]
        if let warmup = workout.warmup { json["warmup"] = try step(warmup) }
        if let cooldown = workout.cooldown { json["cooldown"] = try step(cooldown) }
        return json
    }

    static func singleGoal(_ workout: SingleGoalWorkout) throws -> [String: Any] {
        var json: [String: Any] = [
            "workoutType": "singleGoalWorkout",
            "activityType": try activityName(workout.activity),
            "goal": try goal(workout.goal),
        ]
        if workout.activity == .swimming {
            json["swimmingLocation"] = swimmingLocationName(workout.swimmingLocation)
        } else {
            json["location"] = locationName(workout.location)
        }
        return json
    }

    static func pacer(_ workout: PacerWorkout) throws -> [String: Any] {
        let distance = lengthValue(workout.distance)
        let time = durationValue(workout.time)
        return [
            "workoutType": "pacerWorkout",
            "activityType": try activityName(workout.activity),
            "location": locationName(workout.location),
            "targetValue": distance.value,
            "targetValueUnit": distance.unit,
            "targetDuration": time.seconds,
            "targetDurationUnit": time.unit,
        ]
    }

    static func swimBikeRun(_ workout: SwimBikeRunWorkout) throws -> [String: Any] {
        var json: [String: Any] = [
            "workoutType": "swimBikeRunWorkout",
            "activities": try workout.activities.map { activity -> [String: Any] in
                switch activity {
                case let .swimming(location): return ["type": "swimming", "swimmingLocation": swimmingLocationName(location)]
                case let .cycling(location): return ["type": "cycling", "location": locationName(location)]
                case let .running(location): return ["type": "running", "location": locationName(location)]
                @unknown default:
                    throw WorkoutkitError.serialization("Unsupported multisport activity: \(activity)")
                }
            },
        ]
        if let displayName = workout.displayName { json["displayName"] = displayName }
        return json
    }

    // MARK: Steps

    static func intervalStep(_ intervalStep: IntervalStep) throws -> [String: Any] {
        var json: [String: Any] = ["purpose": intervalStep.purpose == .work ? "work" : "recovery"]
        let stepJson = try step(intervalStep.step)
        if stepJson["displayName"] != nil {
            json["step"] = stepJson
        } else {
            json["goal"] = stepJson["goal"]
            if let alert = stepJson["alert"] { json["alert"] = alert }
        }
        return json
    }

    static func step(_ step: WorkoutStep) throws -> [String: Any] {
        var json: [String: Any] = ["goal": try goal(step.goal)]
        if let alert = step.alert { json["alert"] = try Self.alert(alert) }
        if #available(iOS 18.0, *), let displayName = step.displayName {
            json["displayName"] = displayName
        }
        return json
    }

    // MARK: Goals

    static func goal(_ goal: WorkoutGoal) throws -> [String: Any] {
        switch goal {
        case .open:
            return ["type": "open"]
        case let .distance(value, unit):
            let length = lengthValue(Measurement(value: value, unit: unit))
            return ["type": "distance", "targetValue": length.value, "unit": length.unit]
        case let .time(value, unit):
            let time = durationValue(Measurement(value: value, unit: unit))
            return ["type": "time", "targetDuration": time.seconds, "unit": time.unit]
        case let .energy(value, unit):
            if let name = WorkoutTypeConvert.unitName(of: unit, in: WorkoutTypeConvert.energyUnits) {
                return ["type": "energy", "targetValue": value, "unit": name]
            }
            let kcal = Measurement(value: value, unit: unit).converted(to: .kilocalories).value
            return ["type": "energy", "targetValue": kcal, "unit": "kilocalories"]
        default:
            if #available(iOS 18.0, *), case let .poolSwimDistanceWithTime(distance, duration) = goal {
                let length = lengthValue(distance)
                let time = durationValue(duration)
                return [
                    "type": "poolSwimDistanceWithTime",
                    "targetValue": length.value,
                    "unit": length.unit,
                    "targetDuration": time.seconds,
                    "durationUnit": time.unit,
                ]
            }
            throw WorkoutkitError.serialization("Unsupported goal: \(goal)")
        }
    }

    private static func lengthValue(_ measurement: Measurement<UnitLength>) -> (value: Double, unit: String) {
        if let name = WorkoutTypeConvert.unitName(of: measurement.unit, in: WorkoutTypeConvert.lengthUnits) {
            return (measurement.value, name)
        }
        return (measurement.converted(to: .meters).value, "meters")
    }

    /// Durations travel as seconds (an Int when whole) plus a display unit.
    private static func durationValue(_ measurement: Measurement<UnitDuration>) -> (seconds: Any, unit: String) {
        let seconds = measurement.converted(to: .seconds).value
        let unit = WorkoutTypeConvert.unitName(of: measurement.unit, in: WorkoutTypeConvert.durationUnits) ?? "seconds"
        let rounded = seconds.rounded()
        return (abs(seconds - rounded) < 1e-9 ? Int(rounded) : seconds, unit)
    }

    // MARK: Alerts

    static func alert(_ alert: any WorkoutAlert) throws -> [String: Any] {
        let bpm = WorkoutAlertMetric.countPerMinute
        switch alert {
        case let alert as HeartRateZoneAlert:
            return ["type": "heartRateZone", "zone": alert.zone]
        case let alert as HeartRateRangeAlert:
            return [
                "type": "heartRateRange",
                "lowerBound": alert.target.lowerBound.converted(to: bpm).value,
                "upperBound": alert.target.upperBound.converted(to: bpm).value,
            ]
        case let alert as CadenceRangeAlert:
            return [
                "type": "cadenceRange",
                "lowerBound": alert.target.lowerBound.converted(to: bpm).value,
                "upperBound": alert.target.upperBound.converted(to: bpm).value,
            ]
        case let alert as CadenceThresholdAlert:
            return ["type": "cadenceThreshold", "threshold": alert.target.converted(to: bpm).value]
        case let alert as PowerZoneAlert:
            return ["type": "powerZone", "zone": alert.zone, "metric": metricName(alert.metric)]
        case let alert as PowerRangeAlert:
            return [
                "type": "powerRange",
                "lowerBound": alert.target.lowerBound.converted(to: .watts).value,
                "upperBound": alert.target.upperBound.converted(to: .watts).value,
                "metric": metricName(alert.metric),
            ]
        case let alert as PowerThresholdAlert:
            return [
                "type": "powerThreshold",
                "threshold": alert.target.converted(to: .watts).value,
                "metric": metricName(alert.metric),
            ]
        case let alert as SpeedRangeAlert:
            let unit = speedUnit(alert.target.lowerBound.unit)
            return [
                "type": "speedRange",
                "lowerBound": alert.target.lowerBound.converted(to: unit.unit).value,
                "upperBound": alert.target.upperBound.converted(to: unit.unit).value,
                "unitSpeed": unit.name,
                "metric": metricName(alert.metric),
            ]
        case let alert as SpeedThresholdAlert:
            let unit = speedUnit(alert.target.unit)
            return [
                "type": "speedThreshold",
                "threshold": alert.target.converted(to: unit.unit).value,
                "unitSpeed": unit.name,
                "metric": metricName(alert.metric),
            ]
        default:
            throw WorkoutkitError.serialization("Unsupported alert: \(type(of: alert))")
        }
    }

    private static func metricName(_ metric: WorkoutAlertMetric) -> String {
        WorkoutTypeConvert.name(of: metric, in: WorkoutTypeConvert.alertMetrics) ?? "current"
    }

    private static func speedUnit(_ unit: UnitSpeed) -> (name: String, unit: UnitSpeed) {
        if let name = WorkoutTypeConvert.unitName(of: unit, in: WorkoutTypeConvert.speedUnits) {
            return (name, WorkoutTypeConvert.speedUnits[name]!)
        }
        return ("metersPerSecond", .metersPerSecond)
    }
}
