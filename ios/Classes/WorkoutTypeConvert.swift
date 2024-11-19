import HealthKit
import WorkoutKit

public class WorkoutTypeConvert {

    public static func getCalorieUnit(_ unit: String) -> UnitEnergy {
        switch unit {
        case "calories":
            return .calories
        case "kilocalories":
            return .kilocalories
        default:
            return .kilocalories
        }
    }

    public static func getTimeUnit(_ unit: String) -> UnitDuration {
        switch unit {
        case "minutes":
            return .minutes
        case "hours":
            return .hours
        case "seconds":
            return .seconds
        default:
            return .minutes
        }
    }

    public static func getDistanceUnit(_ unit: String) -> UnitLength {
        switch unit {
        case "kilometers":
            return .kilometers
        case "miles":
            return .miles
        case "meters":
            return .meters
        case "yards":
            return .yards
        default:
            return .meters
        }
    }
    
    public static func convertSwimmingLocationType(_ swimmingLocationType: String) -> HKWorkoutSwimmingLocationType {
        switch swimmingLocationType {
        case "openWater":
            return .openWater
        case "pool":
            return .pool
        default:
            return .unknown
        }
    }
    
  public static func convertLocationType(_ locationType: String) -> HKWorkoutSessionLocationType {
    switch locationType {
      case "outdoor":
        return .outdoor
      case "indoor":
        return .indoor
      default:
        return .unknown
    }
  }

    @available(iOS 17.0, *)
    public static func convertSwimBikeRunActivity(_ activityTypeJson: String, _ locationJson: String) -> SwimBikeRunWorkout.Activity {
      switch activityTypeJson {
        case "cycling":
          let location = convertLocationType(locationJson)
          return .cycling(location)
        case "running":
          let location = convertLocationType(locationJson)
          return .running(location)
      case "swimming":
          let location = convertSwimmingLocationType(locationJson)
          return .swimming(location)
      default:
          return .running(.unknown)
      }
  }
    
    @available(iOS 17.0, *)
    public static func convertWorkoutAlertMetricType(_ metricType: String) -> WorkoutAlertMetric {
        switch metricType {
        case "average":
            return .average
        case "current":
            return .current
        default:
            return .average
        }
        
    }
    
    
    @available(iOS 17.0, *)
    public static func convertUnitSpeed(_ unitSpeed: String) -> UnitSpeed {
        switch unitSpeed {
        case "metersPerSecond":
            return .metersPerSecond
        case "kilometersPerHour":
            return .kilometersPerHour
        case "milesPerHour":
            return .milesPerHour
        case "knots":
            return .knots
        default:
            return .metersPerSecond
        }
        
    }

    public static func convertActivityType(_ activityType: String) -> HKWorkoutActivityType {
    switch activityType {
      case "archery":
        return .archery
      case "badminton":
        return .badminton
      case "baseball":
        return .baseball
      case "basketball":
        return .basketball
      case "bowling":
        return .bowling
      case "boxing":
        return .boxing
      case "climbing":
        return .climbing
      case "crossTraining":
        return .crossTraining
      case "cycling":
        return .cycling
      case "dance":
        return .dance
      case "elliptical":
        return .elliptical
      case "fitnessGaming":
        if #available(iOS 13.0, *) {
            return .fitnessGaming
        } else {
            return .other
        }
      case "functionalStrengthTraining":
        return .functionalStrengthTraining
      case "golf":
        return .golf
      case "hiking":
        return .hiking
      case "hockey":
        return .hockey
      case "jumpRope":
        return .jumpRope
      case "kickboxing":
        return .kickboxing
      case "martialArts":
        return .martialArts
      case "pilates":
        return .pilates
      case "rowing":
        return .rowing
      case "rugby":
        return .rugby
      case "running":
        return .running
      case "sailing":
        return .sailing
      case "skatingSports":
        return .skatingSports
      case "soccer":
        return .soccer
      case "stairs":
        return .stairs
      case "swimming":
        return .swimming
      case "tableTennis":
        return .tableTennis
      case "tennis":
        return .tennis
      case "volleyball":
        return .volleyball
      case "walking":
        return .walking
      case "waterFitness":
        return .waterFitness
      case "waterPolo":
        return .waterPolo
      case "waterSports":
        return .waterSports
      case "wrestling":
        return .wrestling
      case "yoga":
        return .yoga
      default:
        return .other
    }
  }
}
