import HealthKit
import WorkoutKit

/// String ↔ native value tables shared by the builder (Dart → WorkoutKit)
/// and the serializer (WorkoutKit → Dart). Keys match the Dart enum names.
enum WorkoutTypeConvert {
    static let energyUnits: [String: UnitEnergy] = [
        "calories": .calories,
        "kilocalories": .kilocalories,
    ]

    static let durationUnits: [String: UnitDuration] = [
        "seconds": .seconds,
        "minutes": .minutes,
        "hours": .hours,
    ]

    static let lengthUnits: [String: UnitLength] = [
        "meters": .meters,
        "kilometers": .kilometers,
        "miles": .miles,
        "yards": .yards,
    ]

    static let speedUnits: [String: UnitSpeed] = [
        "metersPerSecond": .metersPerSecond,
        "kilometersPerHour": .kilometersPerHour,
        "milesPerHour": .milesPerHour,
        "knots": .knots,
    ]

    static let locations: [String: HKWorkoutSessionLocationType] = [
        "unknown": .unknown,
        "indoor": .indoor,
        "outdoor": .outdoor,
    ]

    static let swimmingLocations: [String: HKWorkoutSwimmingLocationType] = [
        "unknown": .unknown,
        "pool": .pool,
        "openWater": .openWater,
    ]

    static let alertMetrics: [String: WorkoutAlertMetric] = [
        "current": .current,
        "average": .average,
    ]

    static let activityTypes: [String: HKWorkoutActivityType] = [
        "archery": .archery,
        "badminton": .badminton,
        "baseball": .baseball,
        "basketball": .basketball,
        "bowling": .bowling,
        "boxing": .boxing,
        "climbing": .climbing,
        "crossTraining": .crossTraining,
        "cycling": .cycling,
        "cardioDance": .cardioDance,
        "socialDance": .socialDance,
        "elliptical": .elliptical,
        "fitnessGaming": .fitnessGaming,
        "functionalStrengthTraining": .functionalStrengthTraining,
        "golf": .golf,
        "hiking": .hiking,
        "hockey": .hockey,
        "jumpRope": .jumpRope,
        "kickboxing": .kickboxing,
        "martialArts": .martialArts,
        "pilates": .pilates,
        "rowing": .rowing,
        "rugby": .rugby,
        "running": .running,
        "sailing": .sailing,
        "skatingSports": .skatingSports,
        "soccer": .soccer,
        "stairs": .stairs,
        "swimming": .swimming,
        "tableTennis": .tableTennis,
        "tennis": .tennis,
        "volleyball": .volleyball,
        "walking": .walking,
        "waterFitness": .waterFitness,
        "waterPolo": .waterPolo,
        "waterSports": .waterSports,
        "wrestling": .wrestling,
        "yoga": .yoga,
    ]

    /// Accepted when decoding only: the deprecated Dart `dance` value maps to
    /// `cardioDance` (`HKWorkoutActivityType.dance` is deprecated since iOS 14).
    static let activityTypesForDecoding: [String: HKWorkoutActivityType] =
        activityTypes.merging(["dance": .cardioDance]) { current, _ in current }

    /// Reverse lookup for value tables.
    static func name<T: Equatable>(of value: T, in table: [String: T]) -> String? {
        table.first { $0.value == value }?.key
    }

    /// Reverse lookup for `Dimension` units, compared by symbol.
    static func unitName<T: Dimension>(of unit: T, in table: [String: T]) -> String? {
        table.first { $0.value.symbol == unit.symbol }?.key
    }
}
