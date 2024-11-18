import WorkoutKit
import HealthKit


public class WorkoutBuilder {
    @available(iOS 17.0, *)
    public static func parseIntervalBlocks(blocksJson: [[String: Any]]) -> [IntervalBlock] {
        var blocks: [IntervalBlock] = [];

        for block: [String : Any] in blocksJson {
            let steps = parseIntervalSteps(stepsJson: block["steps"] as! [[String: Any]])
            let iterations: Int = block["iterations"] as! Int
            blocks.append(IntervalBlock(steps: steps, iterations: iterations))
        }    

        return blocks;
    }

    @available(iOS 17.0, *)
    public static func createWorkoutStep(stepJson: [String: Any]) -> WorkoutStep {
        let goal = createWorkoutGoal(stepJson["goal"] as! [String: Any])
        // if let alert = stepJson["alert"] as? [String: Any] {
        //     return WorkoutStep(goal: goal, alert: alert)
        // }
        return WorkoutStep(goal: goal)
    }

    @available(iOS 17.0, *)
    private static func createIntervalStep(_ purpose: String) -> IntervalStep {
        switch purpose {
        case "work":
            return IntervalStep(.work)
        case "recovery":
            return IntervalStep(.recovery)
        default:
            return IntervalStep(.work)
        }
    }
    
    @available(iOS 17.0, *)
    public static func parseIntervalSteps(stepsJson: [[String: Any]]) -> [IntervalStep] {
        var steps: [IntervalStep] = []
        for step: [String : Any] in stepsJson {
            var intervalStep = createIntervalStep(step["purpose"] as! String)
            intervalStep.step.goal = createWorkoutGoal(step["goal"] as! [String: Any])
//          intervalStep.step.alert
            steps.append(intervalStep)
        }
        return steps
    }
    
    @available(iOS 17.0, *)
    public static func createWorkoutGoal(_ goalJson: [String: Any]) -> WorkoutGoal {
        let goalType = goalJson["type"] as! String  

        switch goalType {
        case "distance":
            return createDistanceWorkoutGoal(goalJson)
        case "time":
            return createTimeWorkoutGoal(goalJson)
        case "energy":
            return createCalorieWorkoutGoal(goalJson)
        default:
            return .open
        }
    }

    @available(iOS 17.0, *)
    private static func createCalorieWorkoutGoal(_ goalJson: [String: Any]) ->  WorkoutGoal {
        let targetValue = goalJson["targetValue"] as! Double
        let calorieUnit = WorkoutTypeConvert.getCalorieUnit(goalJson["unit"] as! String)
        return .energy(targetValue, calorieUnit)
    }

    @available(iOS 17.0, *)
    private static func createTimeWorkoutGoal(_ goalJson: [String: Any]) -> WorkoutGoal {
        let targetValue = createTargetDuration(goalJson["unit"] as! String, goalJson["targetDuration"] as! Int)
        let timeUnit = WorkoutTypeConvert.getTimeUnit(goalJson["unit"] as! String)
        return .time(targetValue, timeUnit)
    }

    @available(iOS 17.0, *)
    private static func createDistanceWorkoutGoal(_ goalJson: [String: Any]) -> WorkoutGoal {
        let targetValue = goalJson["targetValue"] as! Double
        let distanceUnit = WorkoutTypeConvert.getDistanceUnit(goalJson["unit"] as! String)
        return .distance(targetValue, distanceUnit)
    }
    
    @available(iOS 17.0, *)
    public static func createTargetDuration(_ durationUnit: String, _ durationAsSeconds: Int) -> Double {
        switch durationUnit {
        case "minutes":
            return max(0.0, Double(durationAsSeconds / 60))
        case "hours":
            return max(0.0, Double(durationAsSeconds / 3600))
        case "seconds":
            return Double(durationAsSeconds)
        default:
            return 0.0
        }
    }
}
