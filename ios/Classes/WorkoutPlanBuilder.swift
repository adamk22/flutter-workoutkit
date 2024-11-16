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
                return createCustomWorkoutPlan(workoutJson: workoutJson)
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
        return createCustomWorkoutPlan(workoutJson: workoutJson)
    }

    private static func createPacerWorkoutPlan(workoutJson: [String: Any]) -> WorkoutPlan {
        return createCustomWorkoutPlan(workoutJson: workoutJson)
    }

    private static func createSwimBikeRunWorkoutPlan(workoutJson: [String: Any]) -> WorkoutPlan {
        return createCustomWorkoutPlan(workoutJson: workoutJson)
    }
}
