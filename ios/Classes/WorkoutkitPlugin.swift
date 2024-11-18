import Flutter
import HealthKit
import UIKit
import WorkoutKit
import SwiftUI

public class WorkoutkitPlugin: NSObject, FlutterPlugin {
    private let healthStore = HKHealthStore()
    private var builder: HKWorkoutBuilder?
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "workoutkit", binaryMessenger: registrar.messenger())
    let instance = WorkoutkitPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)

    // Register the view factory
      if #available(iOS 17.0, *) {
          let factory = WorkoutPreviewFactory(messenger: registrar.messenger())
          registrar.register(factory, withId: "workout_preview_button")
      } else {
          // Fallback on earlier versions
      }
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
    case "requestHealthPermissions":
      requestHealthPermissions(result: result)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func requestHealthPermissions(result: @escaping FlutterResult) {
    let typesToShare: Set = [
        HKObjectType.workoutType(),
    ]
    
    let typesToRead: Set = [
        HKObjectType.workoutType(),
    ]
    
    healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { (success, error) in
        print("Health permissions requested: \(success)")
        // return success or error to flutter
        if let error = error {
            result(FlutterError(code: "HEALTH_PERMISSION_ERROR", message: "Error requesting health permissions: \(error)", details: nil))
        } else {
            result(true)
        }
    }
  }
  

  // @available(iOS 17.0, *)
  // private func openWorkoutPlanInWatchApp(workoutPlan: WorkoutPlan) async {
  //   #if os(watchOS)
  //       if #available(watchOS 10.0, *) {
  //       do {
  //           try await workoutPlan.openInWorkoutApp()
  //       } catch {
  //           print("Error opening workout plan in watch app: \(error)")
  //       }
  //   } else {
  //       print("Not available on versions below watchOS 10.0")
  //   }
  //   #else
    
  //   print("Opening workout plan in watch app is only available on watchOS")
  //   #endif
  // }
}
