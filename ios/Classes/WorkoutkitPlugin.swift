import Flutter
import HealthKit
import UIKit
import WorkoutKit

public class WorkoutkitPlugin: NSObject, FlutterPlugin {
    private let healthStore = HKHealthStore()
    private var builder: HKWorkoutBuilder?
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "workoutkit", binaryMessenger: registrar.messenger())
    let instance = WorkoutkitPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
    case "createCustomWorkout":
            if let args = call.arguments as? [String: Any],
               let workoutJson = args as? [String: Any] {
                print("workoutJson: \(workoutJson)")
                // createCustomWorkout(workoutJson: workoutJson)
                result("Workout created!")
            } else {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "Activity type required", details: nil))
            }
    default:
      result(FlutterMethodNotImplemented)
    }
  }

    @available(iOS 17.0, *)
    private func parseCustomWorkout(createCustomWorkout: [String: Any]) -> CustomWorkout {
    // Implement parsing logic here
      return CustomWorkout(activity: HKWorkoutActivityType.running)
  }

  private func createCustomWorkout(activityType: String) {
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = .running  // Replace with activityType conversion logic

        builder = HKWorkoutBuilder(healthStore: healthStore, configuration: configuration, device: .local())
        builder?.beginCollection(withStart: Date()) { (success, error) in
            if let error = error {
                print("Error starting workout: \(error)")
                return
            }
            print("Workout started successfully!")
        }
    }
}
