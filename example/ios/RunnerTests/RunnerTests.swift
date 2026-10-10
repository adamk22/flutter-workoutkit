import Flutter
import UIKit
import WorkoutKit
import XCTest

@testable import flutter_workoutkit

/// Exercises the method channel handler end to end (minus Dart).
class RunnerTests: XCTestCase {
    private func call(_ method: String, _ arguments: Any? = nil) -> Any? {
        let plugin = WorkoutkitPlugin()
        let done = expectation(description: method)
        var value: Any?
        plugin.handle(FlutterMethodCall(methodName: method, arguments: arguments)) { result in
            value = result
            done.fulfill()
        }
        wait(for: [done], timeout: 5)
        return value
    }

    func testGetPlatformVersion() {
        XCTAssertEqual(call("getPlatformVersion") as? String, "iOS " + UIDevice.current.systemVersion)
    }

    func testUnknownMethod() {
        XCTAssertTrue(call("nope") as AnyObject === FlutterMethodNotImplemented)
        XCTAssertTrue(call("scheduler.nope") as AnyObject === FlutterMethodNotImplemented)
    }

    func testValidateAcceptsTheFixtures() throws {
        for name in Fixtures.workoutFixtures {
            if name == "pool_swim_workout.json", #unavailable(iOS 18.0) { continue }
            let result = try XCTUnwrap(call("validate", Fixtures.object(name)) as? [String: Any])
            XCTAssertEqual(result["isValid"] as? Bool, true, "\(name): \(result["issues"] ?? "")")
        }
    }

    func testValidateReportsUnsupportedActivity() throws {
        var pacer = try Fixtures.object("pacer_workout.json")
        pacer["activityType"] = "archery"
        let result = try XCTUnwrap(call("validate", pacer) as? [String: Any])
        XCTAssertEqual(result["isValid"] as? Bool, false)
        XCTAssertEqual((result["issues"] as? [String])?.count, 1)
    }

    func testValidateReportsMalformedInputAsAnIssue() throws {
        let result = try XCTUnwrap(call("validate", ["workoutType": "pacerWorkout"]) as? [String: Any])
        XCTAssertEqual(result["isValid"] as? Bool, false)
    }

    func testExportAndImport() throws {
        let fixture = try Fixtures.object("swim_bike_run_workout.json")
        let data = try XCTUnwrap(call("exportPlan", fixture) as? FlutterStandardTypedData)
        let imported = try XCTUnwrap(call("importPlan", data) as? [String: Any])
        XCTAssertEqual(imported["workoutType"] as? String, "swimBikeRunWorkout")
        XCTAssertEqual(imported["displayName"] as? String, "Sprint Triathlon")
    }

    func testErrorsAreFlutterErrors() {
        let error = call("exportPlan", ["workoutType": "pacerWorkout"]) as? FlutterError
        XCTAssertEqual(error?.code, "INVALID_ARGUMENT")
        let importError = call("importPlan", FlutterStandardTypedData(bytes: Data([1, 2, 3]))) as? FlutterError
        XCTAssertEqual(importError?.code, "SERIALIZATION_ERROR")
    }

    func testSchedulerQueriesDoNotCrash() {
        XCTAssertNotNil(call("scheduler.isSupported") as? Bool)
        XCTAssertNotNil(call("scheduler.maxAllowedScheduledWorkoutCount") as? Int)
    }

    func testPreviewButtonStyleParsing() {
        let style = WorkoutPreviewButtonStyle([
            "buttonTitle": "Go",
            "backgroundColor": 0xFF11_2233,
            "fontWeight": "w700",
            "sfSymbol": "applewatch",
            "buttonHeight": 60,
        ])
        XCTAssertEqual(style.buttonTitle, "Go")
        XCTAssertEqual(style.fontWeight, .bold)
        XCTAssertEqual(style.sfSymbol, "applewatch")
        XCTAssertEqual(style.buttonHeight, 60)
        XCTAssertNil(WorkoutPreviewButtonStyle([:]).sfSymbol)

        var red: CGFloat = 0, alpha: CGFloat = 0
        UIColor(argb: 0x80FF_0000).getRed(&red, green: nil, blue: nil, alpha: &alpha)
        XCTAssertEqual(red, 1)
        XCTAssertEqual(alpha, 128.0 / 255.0, accuracy: 0.001)
    }

    func testPreviewBridgeReportsBuildErrors() throws {
        let messenger = MockBinaryMessenger()
        let bad = WorkoutPreviewBridge(
            frame: .zero, viewIdentifier: 1,
            arguments: ["workoutJson": ["workoutType": "nope"]],
            messenger: messenger
        )
        XCTAssertNotNil(bad.view())
        let error = try withExtendedLifetime(bad) {
            try XCTUnwrap(messenger.invoke("workout_preview_button_1", "getBuildError") as? [String: String])
        }
        XCTAssertEqual(error["code"], "INVALID_ARGUMENT")

        let good = WorkoutPreviewBridge(
            frame: .zero, viewIdentifier: 2,
            arguments: ["workoutJson": try Fixtures.object("pacer_workout.json")],
            messenger: messenger
        )
        XCTAssertNotNil(good.view())
        withExtendedLifetime(good) {
            XCTAssertNil(messenger.invoke("workout_preview_button_2", "getBuildError"))
        }
    }
}

/// Records channel handlers so tests can call them like Dart would.
final class MockBinaryMessenger: NSObject, FlutterBinaryMessenger {
    private var handlers: [String: FlutterBinaryMessageHandler] = [:]

    func send(onChannel channel: String, message: Data?) {}
    func send(onChannel channel: String, message: Data?, binaryReply callback: FlutterBinaryReply? = nil) {}

    func setMessageHandlerOnChannel(
        _ channel: String,
        binaryMessageHandler handler: FlutterBinaryMessageHandler? = nil
    ) -> FlutterBinaryMessengerConnection {
        handlers[channel] = handler
        return 0
    }

    func cleanUpConnection(_ connection: FlutterBinaryMessengerConnection) {}

    /// Sends a method call on `channel` and decodes the success reply.
    func invoke(_ channel: String, _ method: String) -> Any? {
        let codec = FlutterStandardMethodCodec.sharedInstance()
        var reply: Any?
        handlers[channel]?(codec.encode(FlutterMethodCall(methodName: method, arguments: nil))) { data in
            reply = data.flatMap { codec.decodeEnvelope($0) }
        }
        return reply
    }
}
