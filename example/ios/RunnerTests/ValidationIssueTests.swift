import Flutter
import WorkoutKit
import XCTest

@testable import flutter_workoutkit

/// Structured validation issues: codes and paths reported to Dart.
final class ValidationIssueTests: XCTestCase {
    override func tearDown() {
        PlatformFeatures.current = .system
        super.tearDown()
    }

    private func customRun(steps: [[String: Any]]) -> [String: Any] {
        [
            "workoutType": "customWorkout",
            "activityType": "running",
            "location": "outdoor",
            "displayName": "Test",
            "blocks": [["iterations": 1, "steps": steps]],
        ]
    }

    func testUnsupportedActivityHasCodeAndPath() throws {
        var pacer = try Fixtures.object("pacer_workout.json")
        pacer["activityType"] = "archery"
        let issues = WorkoutValidator.issues(for: pacer)
        XCTAssertEqual(issues.map(\.code), [.unsupportedActivity])
        XCTAssertEqual(issues.first?.path, "activityType")
    }

    func testUnsupportedGoalPointsAtTheStep() {
        guard #available(iOS 18.0, *) else { return }
        let json = customRun(steps: [
            ["purpose": "work", "goal": ["type": "open"]],
            ["purpose": "work", "goal": [
                "type": "poolSwimDistanceWithTime", "targetValue": 100, "unit": "meters",
                "targetDuration": 120,
            ]],
        ])
        let issues = WorkoutValidator.issues(for: json)
        XCTAssertEqual(issues.map(\.code), [.unsupportedGoal])
        XCTAssertEqual(issues.first?.path, "blocks[0].steps[1]")
    }

    func testMissingBlocksAndActivities() {
        var custom = customRun(steps: [])
        custom["blocks"] = []
        XCTAssertEqual(WorkoutValidator.issues(for: custom).map(\.code), [.missingBlocks])

        let multisport: [String: Any] = ["workoutType": "swimBikeRunWorkout", "activities": []]
        XCTAssertEqual(WorkoutValidator.issues(for: multisport).map(\.code), [.missingActivities])
    }

    func testUnsupportedOSPointsAtTheGoal() throws {
        PlatformFeatures.current = .iOS17_0
        let issues = WorkoutValidator.issues(for: try Fixtures.object("pool_swim_workout.json"))
        XCTAssertEqual(issues.map(\.code), [.unsupportedOS])
        XCTAssertEqual(issues.first?.path, "blocks[0].steps[0].goal")
    }

    func testMalformedJSONIsInvalidWorkoutWithPath() {
        let issues = WorkoutValidator.issues(for: ["workoutType": "pacerWorkout", "activityType": 5])
        XCTAssertEqual(issues.map(\.code), [.invalidWorkout])
        XCTAssertEqual(issues.first?.path, "activityType")
    }

    func testValidateReturnsMessagesAndDetails() throws {
        var pacer = try Fixtures.object("pacer_workout.json")
        pacer["activityType"] = "archery"
        let result = try XCTUnwrap(invoke(WorkoutkitPlugin(), "validate", pacer) as? [String: Any])
        XCTAssertEqual(result["isValid"] as? Bool, false)
        XCTAssertEqual((result["issues"] as? [String])?.count, 1)
        let details = try XCTUnwrap(result["details"] as? [[String: Any]])
        XCTAssertEqual(details.first?["code"] as? String, "unsupportedActivity")
        XCTAssertEqual(details.first?["message"] as? String, (result["issues"] as? [String])?.first)
    }

    func testUnsupportedOSErrorsCarryDetails() {
        let error = WorkoutkitError.unsupportedOS(feature: "X", minimum: "18.0", path: "goal").flutterError
        XCTAssertEqual(error.code, "UNSUPPORTED_OS")
        XCTAssertEqual((error.details as? [[String: Any]])?.first?["path"] as? String, "goal")
    }
}
