import Flutter
import HealthKit
import UIKit
import WorkoutKit

public class WorkoutkitPlugin: NSObject, FlutterPlugin {
    private let healthStore = HKHealthStore()
    private let scheduler: WorkoutScheduling
    private let schedulerIsSupported: () -> Bool
    private let maxAllowedScheduledWorkoutCount: Int
    private var previewPresenter: WorkoutPreviewPresenter?

    override public convenience init() {
        self.init(
            scheduler: WorkoutScheduler.shared,
            schedulerIsSupported: { WorkoutScheduler.isSupported },
            maxAllowedScheduledWorkoutCount: WorkoutScheduler.maxAllowedScheduledWorkoutCount
        )
    }

    /// Injection point for tests.
    init(
        scheduler: WorkoutScheduling,
        schedulerIsSupported: @escaping () -> Bool,
        maxAllowedScheduledWorkoutCount: Int
    ) {
        self.scheduler = scheduler
        self.schedulerIsSupported = schedulerIsSupported
        self.maxAllowedScheduledWorkoutCount = maxAllowedScheduledWorkoutCount
        super.init()
    }

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "workoutkit", binaryMessenger: registrar.messenger())
        let instance = WorkoutkitPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        registrar.register(
            WorkoutPreviewFactory(messenger: registrar.messenger()),
            withId: "workout_preview_button"
        )
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getPlatformVersion":
            result("iOS " + UIDevice.current.systemVersion)
        case "requestHealthPermissions":
            requestHealthPermissions(result: result)
        case "hasHealthPermissions":
            result(healthStore.authorizationStatus(for: HKObjectType.workoutType()) == .sharingAuthorized)
        case "validate":
            let issues = WorkoutValidator.issues(for: call.arguments)
            result([
                "isValid": issues.isEmpty,
                "issues": issues.map(\.message),
                "details": issues.map(\.dictionary),
            ])
        case "exportPlan":
            respond(result) {
                let plan = try WorkoutPlanBuilder.plan(from: call.arguments)
                do {
                    return FlutterStandardTypedData(bytes: try plan.dataRepresentation)
                } catch {
                    throw WorkoutkitError.serialization("Could not export workout: \(error.localizedDescription)")
                }
            }
        case "importPlan":
            respond(result) {
                guard let data = call.arguments as? FlutterStandardTypedData else {
                    throw WorkoutkitError.invalidArgument(path: "$", expected: "Uint8List")
                }
                let plan: WorkoutPlan
                do {
                    plan = try WorkoutPlan(from: data.data)
                } catch {
                    throw WorkoutkitError.serialization("Could not import workout: \(error.localizedDescription)")
                }
                return try WorkoutPlanSerializer.json(plan)
            }
        case "presentPreview":
            presentPreview(call.arguments, result)
        case let method where method.hasPrefix("scheduler."):
            handleScheduler(String(method.dropFirst("scheduler.".count)), call.arguments, result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    /// Runs `body` and reports its value, or its `WorkoutkitError`, to Dart.
    private func respond(_ result: FlutterResult, _ body: () throws -> Any?) {
        do {
            result(try body())
        } catch let error as WorkoutkitError {
            result(error.flutterError)
        } catch {
            result(FlutterError(code: "UNKNOWN", message: "\(error)", details: nil))
        }
    }

    private func respondAsync(_ result: @escaping FlutterResult, _ body: @escaping () async throws -> Any?) {
        Task { @MainActor in
            do {
                result(try await body())
            } catch let error as WorkoutkitError {
                result(error.flutterError)
            } catch {
                result(FlutterError(code: "UNKNOWN", message: "\(error)", details: nil))
            }
        }
    }

    // MARK: Preview

    private func presentPreview(_ arguments: Any?, _ result: @escaping FlutterResult) {
        let plan: WorkoutPlan
        do {
            plan = try WorkoutPlanBuilder.plan(from: arguments)
        } catch let error as WorkoutkitError {
            result(error.flutterError)
            return
        } catch {
            result(FlutterError(code: "UNKNOWN", message: "\(error)", details: nil))
            return
        }
        MainActor.assumeIsolated {
            let presenter = previewPresenter ?? WorkoutPreviewPresenter()
            previewPresenter = presenter
            do {
                try presenter.present(plan) { result(nil) }
            } catch let error as WorkoutkitError {
                result(error.flutterError)
            } catch {
                result(FlutterError(code: "UNKNOWN", message: "\(error)", details: nil))
            }
        }
    }

    // MARK: Scheduler

    private func handleScheduler(_ method: String, _ arguments: Any?, _ result: @escaping FlutterResult) {
        let scheduler = self.scheduler
        switch method {
        case "isSupported":
            result(schedulerIsSupported())
        case "maxAllowedScheduledWorkoutCount":
            result(maxAllowedScheduledWorkoutCount)
        case "authorizationState":
            respondAsync(result) { Self.name(of: await scheduler.authorizationState) }
        case "requestAuthorization":
            respondAsync(result) { Self.name(of: await scheduler.requestAuthorization()) }
        case "schedule":
            respondAsync(result) {
                let json = try JSONReader(any: arguments)
                let plan = try WorkoutPlanBuilder.plan(json.object("workout"))
                let date = try SchedulerDate.components(json.object("date"))
                await scheduler.schedule(plan, at: date)
                return try Self.json(ScheduledWorkoutPlan(plan, date: date))
            }
        case "scheduledWorkouts":
            respondAsync(result) {
                try await scheduler.scheduledWorkouts.map(Self.json)
            }
        case "remove", "markComplete":
            respondAsync(result) {
                let json = try JSONReader(any: arguments)
                let id = try json.string("id")
                let date = try SchedulerDate.components(json.object("date"))
                let scheduled = await scheduler.scheduledWorkouts.first {
                    $0.plan.id.uuidString.caseInsensitiveCompare(id) == .orderedSame
                        && SchedulerDate.matches($0.date, date)
                }
                guard let scheduled else {
                    throw WorkoutkitError.notFound("No scheduled workout with id \(id) at that date")
                }
                if method == "remove" {
                    await scheduler.remove(scheduled.plan, at: scheduled.date)
                } else {
                    await scheduler.markComplete(scheduled.plan, at: scheduled.date)
                }
                return nil
            }
        case "removeAll":
            respondAsync(result) {
                await scheduler.removeAllWorkouts()
                return nil
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private static func name(of state: WorkoutScheduler.AuthorizationState) -> String {
        switch state {
        case .notDetermined: return "notDetermined"
        case .restricted: return "restricted"
        case .denied: return "denied"
        case .authorized: return "authorized"
        @unknown default: return "notDetermined"
        }
    }

    private static func json(_ scheduled: ScheduledWorkoutPlan) throws -> [String: Any] {
        [
            "workout": try WorkoutPlanSerializer.json(scheduled.plan),
            "date": SchedulerDate.json(scheduled.date),
            "complete": scheduled.complete,
        ]
    }

    // MARK: HealthKit (deprecated on the Dart side)

    private func requestHealthPermissions(result: @escaping FlutterResult) {
        let types: Set = [HKObjectType.workoutType()]
        healthStore.requestAuthorization(toShare: types, read: types) { _, error in
            DispatchQueue.main.async {
                if let error {
                    result(FlutterError(
                        code: "HEALTH_PERMISSION_ERROR",
                        message: "Error requesting health permissions: \(error.localizedDescription)",
                        details: nil
                    ))
                } else {
                    result(true)
                }
            }
        }
    }
}

/// Converts between the Dart `{year, month, day, hour, minute}` map and
/// `DateComponents` in the user's current calendar.
enum SchedulerDate {
    private static let fields: [(String, Calendar.Component)] = [
        ("year", .year), ("month", .month), ("day", .day), ("hour", .hour), ("minute", .minute),
    ]

    static func components(_ json: JSONReader) throws -> DateComponents {
        var components = DateComponents()
        components.calendar = Calendar.current
        components.timeZone = TimeZone.current
        for (key, component) in fields {
            components.setValue(try json.int(key), for: component)
        }
        guard components.isValidDate else {
            throw WorkoutkitError.invalidArgument(path: json.path, expected: "a valid date")
        }
        return components
    }

    static func json(_ components: DateComponents) -> [String: Int] {
        var json: [String: Int] = [:]
        for (key, component) in fields {
            if let value = components.value(for: component), value != NSDateComponentUndefined {
                json[key] = value
            }
        }
        return json
    }

    static func matches(_ lhs: DateComponents, _ rhs: DateComponents) -> Bool {
        fields.allSatisfy { lhs.value(for: $0.1) == rhs.value(for: $0.1) }
    }
}
