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
    public static func createActivities(activitiesJson: [[String: Any]]) -> [SwimBikeRunWorkout.Activity] {
        var activities: [SwimBikeRunWorkout.Activity] = []
        for activityJson: [String: Any] in activitiesJson {
            let activityTypeJson = activityJson["type"] as! String
            var locationJson: String
            if (activityTypeJson == "swimming") {
                locationJson = activityJson["swimmingLocation"] as! String
            } else {
                locationJson = activityJson["location"] as! String
            }
            let activity = WorkoutTypeConvert.convertSwimBikeRunActivity(activityTypeJson, locationJson);
            activities.append(activity)
        }
        return activities
    }
    
    @available(iOS 17.0, *)
    public static func createWorkoutAlert(_ alertJson: [String: Any]) -> any WorkoutAlert {
        let type = alertJson["type"] as! String

        switch type {
        case "heartRateZone":
            let zone = alertJson["zone"] as! Int
            return .heartRate(zone: zone)
        case "heartRateRange":
            let lowerBound = alertJson["lowerBound"] as! Double
            let upperBound = alertJson["upperBound"] as! Double
            return .heartRate(lowerBound...upperBound)
        case "cadenceRange":
            let lowerBound = alertJson["lowerBound"] as! Double
            let upperBound = alertJson["upperBound"] as! Double
            return .cadence(lowerBound...upperBound)
        case "cadenceThreshold":
            let threshold = alertJson["threshold"] as! Double
            return .cadence(threshold)
        case "powerRange":
            let lowerBound = alertJson["lowerBound"] as! Double
            let upperBound = alertJson["upperBound"] as! Double
            if #available(iOS 17.4, *) {
                let metric = WorkoutTypeConvert.convertWorkoutAlertMetricType(alertJson["metric"] as! String)
                return .power(lowerBound...upperBound, unit: .watts, metric: metric)
            } else {
                return .power(lowerBound...upperBound, unit: .watts)
            }
        case "powerThreshold":
            let threshold = alertJson["threshold"] as! Double
            let metric = alertJson["metric"] as! String
            if #available(iOS 17.4, *) {
                let metric = WorkoutTypeConvert.convertWorkoutAlertMetricType(alertJson["metric"] as! String)
                return .power(threshold, unit: .watts, metric: metric)
            } else {
                return .power(threshold, unit: .watts)
            }
        case "powerZone":
            let zone = alertJson["zone"] as! Int
            return .power(zone: zone)
        case "speedRange":
            let lowerBound = alertJson["lowerBound"] as! Double
            let upperBound = alertJson["upperBound"] as! Double
            let unitSpeed = WorkoutTypeConvert.convertUnitSpeed(alertJson["unitSpeed"] as! String)
            
            if #available(iOS 17.4, *) {
                let metric = WorkoutTypeConvert.convertWorkoutAlertMetricType(alertJson["metric"] as! String)
                return .speed(lowerBound...upperBound, unit: unitSpeed, metric: metric)
            } else {
                return .speed(lowerBound...upperBound, unit: unitSpeed)
            }
        case "speedThreshold":
            let threshold = alertJson["threshold"] as! Double
            let unitSpeed = WorkoutTypeConvert.convertUnitSpeed(alertJson["unitSpeed"] as! String)
            
            if #available(iOS 17.4, *) {
                let metric = WorkoutTypeConvert.convertWorkoutAlertMetricType(alertJson["metric"] as! String)
                return .speed(threshold, unit: unitSpeed, metric: metric)
            } else {
                return .speed(threshold, unit: unitSpeed)
            }
        default:
            return .heartRate(zone: 1)
        }
    }

    @available(iOS 17.0, *)
    public static func createWorkoutStep(stepJson: [String: Any]) -> WorkoutStep {
        let goal = createWorkoutGoal(stepJson["goal"] as! [String: Any])
        let displayName = stepJson["displayName"] as? String
        
        var step: WorkoutStep
        if let displayName = displayName {
            if #available(iOS 18.0, *) {
                step = WorkoutStep(goal: goal, displayName: displayName)
            } else {
                step = WorkoutStep(goal: goal)
            }
        } else {
            step = WorkoutStep(goal: goal)
        }
        
        if let alert = stepJson["alert"] as? [String: Any] {
            step.alert = createWorkoutAlert(alert)
        }
        
        return step
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
            
            if let goalJson = step["goal"] as? [String: Any] {
                intervalStep.step.goal = createWorkoutGoal(goalJson)
            } else if let stepJson = step["step"] as? [String: Any] {
                intervalStep.step = createWorkoutStep(stepJson: stepJson)
            }

            if let alert = step["alert"] as? [String: Any] {
                intervalStep.step.alert = createWorkoutAlert(alert)
            }

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
