import Flutter
import Foundation
import XCTest

/// Loads the shared JSON contract fixtures from `<repo>/test/fixtures`.
enum Fixtures {
    static let directory = URL(fileURLWithPath: #filePath)
        .deletingLastPathComponent() // RunnerTests
        .deletingLastPathComponent() // ios
        .deletingLastPathComponent() // example
        .deletingLastPathComponent() // repository root
        .appendingPathComponent("test/fixtures")

    static func load(_ name: String) throws -> Any {
        let data = try Data(contentsOf: directory.appendingPathComponent(name))
        return try JSONSerialization.jsonObject(with: data)
    }

    static func object(_ name: String) throws -> [String: Any] {
        try XCTUnwrap(load(name) as? [String: Any])
    }

    static func array(_ name: String) throws -> [[String: Any]] {
        try XCTUnwrap(load(name) as? [[String: Any]])
    }

    static let workoutFixtures = [
        "custom_workout.json",
        "single_goal_workout.json",
        "single_goal_swimming_workout.json",
        "pool_swim_workout.json",
        "pacer_workout.json",
        "swim_bike_run_workout.json",
    ]
}

extension XCTestCase {
    /// Invokes a method channel call on `plugin` and waits for the result.
    func invoke(_ plugin: FlutterPlugin, _ method: String, _ arguments: Any? = nil) -> Any? {
        let done = expectation(description: method)
        var value: Any?
        plugin.handle?(FlutterMethodCall(methodName: method, arguments: arguments)) { result in
            value = result
            done.fulfill()
        }
        wait(for: [done], timeout: 5)
        return value
    }
}
