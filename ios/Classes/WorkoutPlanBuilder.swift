import WorkoutKit
import HealthKit

@available(iOS 17.0, *)
public class WorkoutPlanBuilder {
    public static func createWorkoutPlan(workoutJson: [String: Any]) -> WorkoutPlan {
        let workoutType = WorkoutType(rawValue: workoutJson["workoutType"] as! String)

        switch workoutType {
            case .customWorkout:
                return createCustomWorkoutPlan(workoutJson: workoutJson)
            case .singleGoalWorkout:
                return createSingleGoalWorkoutPlan(workoutJson: workoutJson)
            case .pacerWorkout:
                return createPacerWorkoutPlan(workoutJson: workoutJson)
            case .swimBikeRunWorkout:
                return createSwimBikeRunWorkoutPlan(workoutJson: workoutJson)
            default:
                fatalError("Unknown workout type")
        }
    }

    private static func createCustomWorkoutPlan(workoutJson: [String: Any]) -> WorkoutPlan {
        let displayName = workoutJson["displayName"] as! String
        let activityType = WorkoutTypeConvert.convertActivityType(workoutJson["activityType"] as! String)
        let location = WorkoutTypeConvert.convertLocationType(workoutJson["location"] as! String)
        let blocks = WorkoutBuilder.parseIntervalBlocks(blocksJson: workoutJson["blocks"] as! [[String: Any]])
        
        var warmup: WorkoutStep? = nil
        if let warmupJson = workoutJson["warmup"] as? [String: Any] {
            warmup = WorkoutBuilder.createWorkoutStep(stepJson: warmupJson)
        }
        
        var cooldown: WorkoutStep? = nil
        if let cooldownJson = workoutJson["cooldown"] as? [String: Any] {
            cooldown = WorkoutBuilder.createWorkoutStep(stepJson: cooldownJson)
        }
        
        let customWorkout = CustomWorkout(activity: activityType, location: location, displayName: displayName, warmup: warmup, blocks: blocks, cooldown: cooldown)
        let workoutPlan = WorkoutPlan(.custom(customWorkout))
        return workoutPlan
    }

    private static func createSingleGoalWorkoutPlan(workoutJson: [String: Any]) -> WorkoutPlan {
        let goal = WorkoutBuilder.createWorkoutGoal(workoutJson["goal"] as! [String: Any])
        let activityType = WorkoutTypeConvert.convertActivityType(workoutJson["activityType"] as! String)

        var singleGoalWorkout: SingleGoalWorkout
        if (activityType == .swimming) {
            guard let swimmingLocationString = workoutJson["swimmingLocation"] as? String else {
                fatalError("Swimming workout must have a swimming location")
            }
            let swimmingLocation = WorkoutTypeConvert.convertSwimmingLocationType(swimmingLocationString)
            singleGoalWorkout = SingleGoalWorkout(activity: activityType, swimmingLocation: swimmingLocation, goal: goal)
        } else {
            let location = WorkoutTypeConvert.convertLocationType(workoutJson["location"] as! String)
            singleGoalWorkout = SingleGoalWorkout(activity: activityType, location: location, goal: goal)
        }
        
        let workoutPlan = WorkoutPlan(.goal(singleGoalWorkout))
        return workoutPlan
    }

    private static func createPacerWorkoutPlan(workoutJson: [String: Any]) -> WorkoutPlan {
        let activityType = WorkoutTypeConvert.convertActivityType(workoutJson["activityType"] as! String)
        let location = WorkoutTypeConvert.convertLocationType(workoutJson["location"] as! String)
        let targetValue = workoutJson["targetValue"] as! Double
        let targetValueUnit = WorkoutTypeConvert.getDistanceUnit(workoutJson["targetValueUnit"] as! String)
        let targetDuration = WorkoutBuilder.createTargetDuration(workoutJson["targetDurationUnit"] as! String, workoutJson["targetDuration"] as! Int)
        let targetDurationUnit = WorkoutTypeConvert.getTimeUnit(workoutJson["targetDurationUnit"] as! String)

        let distance: Measurement<UnitLength> = Measurement(value: targetValue, unit: targetValueUnit)
        let time: Measurement<UnitDuration> = Measurement(value: targetDuration, unit: targetDurationUnit)
        
        let pacerWorkout = PacerWorkout(activity: activityType, location: location, distance: distance, time: time)
        let workoutPlan = WorkoutPlan(.pacer(pacerWorkout))

        return workoutPlan
    }

    private static func createSwimBikeRunWorkoutPlan(workoutJson: [String: Any]) -> WorkoutPlan {
        let activities = WorkoutBuilder.createActivities(activitiesJson: workoutJson["activities"] as! [[String: Any]])
        
        var swimBikeRunWorkout: SwimBikeRunWorkout
        if let displayName = workoutJson["displayName"] as? String {
            swimBikeRunWorkout = SwimBikeRunWorkout(activities: activities, displayName: displayName)
        } else {
            swimBikeRunWorkout = SwimBikeRunWorkout(activities: activities)
        }
        
        let workoutPlan = WorkoutPlan(.swimBikeRun(swimBikeRunWorkout))
        
        return workoutPlan
    }
}
