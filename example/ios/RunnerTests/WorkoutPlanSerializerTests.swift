import Flutter
import WorkoutKit
import XCTest

@testable import flutter_workoutkit

/// WorkoutPlan → Dart JSON (used for scheduled and imported workouts).
final class WorkoutPlanSerializerTests: XCTestCase {
    func testSerializedPlansRebuildToEqualPlans() throws {
        for name in Fixtures.workoutFixtures {
            if name == "pool_swim_workout.json", #unavailable(iOS 18.0) { continue }
            let plan = try WorkoutPlanBuilder.plan(from: Fixtures.object(name))
            let json = try WorkoutPlanSerializer.json(plan)
            XCTAssertEqual(try WorkoutPlanBuilder.plan(from: json), plan, name)
        }
    }

    func testSerializedJSONMatchesTheDartContract() throws {
        guard #available(iOS 18.0, *) else { throw XCTSkip("step display names need iOS 18") }
        for name in Fixtures.workoutFixtures {
            let fixture = try Fixtures.object(name)
            let plan = try WorkoutPlanBuilder.plan(from: fixture)
            var json = try WorkoutPlanSerializer.json(plan)
            if fixture["id"] == nil { json["id"] = nil }
            XCTAssertEqual(json as NSDictionary, fixture as NSDictionary, name)
        }
    }

    func testGoalsAndNonPaceAlertsMatchFixtures() throws {
        for goal in try Fixtures.array("goals.json") {
            let built = try WorkoutBuilder.workoutGoal(JSONReader(goal))
            XCTAssertEqual(try WorkoutPlanSerializer.goal(built) as NSDictionary, goal as NSDictionary)
        }
        for alert in try Fixtures.array("alerts.json") where !(alert["type"] as! String).hasPrefix("pace") {
            let built = try WorkoutBuilder.workoutAlert(JSONReader(alert))
            XCTAssertEqual(try WorkoutPlanSerializer.alert(built) as NSDictionary, alert as NSDictionary)
        }
    }

    func testPaceAlertsComeBackAsSpeedAlerts() throws {
        let pace = try Fixtures.array("alerts.json").first { $0["type"] as? String == "paceRange" }!
        let json = try WorkoutPlanSerializer.alert(WorkoutBuilder.workoutAlert(JSONReader(pace)))
        XCTAssertEqual(json["type"] as? String, "speedRange")
        XCTAssertEqual(json["unitSpeed"] as? String, "metersPerSecond")
        XCTAssertEqual(json["upperBound"] as? Double ?? 0, 1000.0 / 300.0, accuracy: 1e-9)
    }

    func testExportImportRoundTrip() throws {
        let plan = try WorkoutPlanBuilder.plan(from: Fixtures.object("custom_workout.json"))
        XCTAssertEqual(try WorkoutPlan(from: plan.dataRepresentation), plan)
    }

    func testSchedulerDateComponents() throws {
        let components = try SchedulerDate.components(
            JSONReader(["year": 2026, "month": 10, "day": 12, "hour": 7, "minute": 30])
        )
        XCTAssertEqual(SchedulerDate.json(components), ["year": 2026, "month": 10, "day": 12, "hour": 7, "minute": 30])
        XCTAssertTrue(SchedulerDate.matches(components, components))
        XCTAssertThrowsError(try SchedulerDate.components(
            JSONReader(["year": 2026, "month": 2, "day": 31, "hour": 7, "minute": 30])
        ))
    }
}
