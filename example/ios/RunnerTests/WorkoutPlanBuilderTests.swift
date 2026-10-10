import HealthKit
import WorkoutKit
import XCTest

@testable import flutter_workoutkit

/// Builds WorkoutKit plans from the shared fixtures and compares them with
/// hand-built plans, so the Dart JSON contract and the Swift builders can't
/// drift apart.
final class WorkoutPlanBuilderTests: XCTestCase {
    private func plan(_ fixture: String) throws -> WorkoutPlan {
        try WorkoutPlanBuilder.plan(from: Fixtures.object(fixture))
    }

    private func alert(_ alert: any WorkoutAlert) -> AnyHashable { AnyHashable(alert) }

    func testCustomWorkout() throws {
        let hrZone1: any WorkoutAlert = .heartRate(zone: 1)
        let hrRange: any WorkoutAlert = .heartRate(150...170)
        let cadence: any WorkoutAlert = .cadence(170...185)

        var warmup = WorkoutStep(goal: .time(5, .minutes), alert: hrZone1)
        var strides = WorkoutStep(goal: .open, alert: cadence)
        if #available(iOS 18.0, *) {
            warmup.displayName = "Easy warmup"
            strides.displayName = "Strides"
        }
        let expected = WorkoutPlan(
            .custom(CustomWorkout(
                activity: .running,
                location: .outdoor,
                displayName: "Intervals",
                warmup: warmup,
                blocks: [
                    IntervalBlock(steps: [
                        IntervalStep(.work, goal: .distance(1, .kilometers), alert: hrRange),
                        IntervalStep(.recovery, goal: .time(90, .seconds)),
                    ], iterations: 4),
                    IntervalBlock(steps: [IntervalStep(.work, step: strides)], iterations: 1),
                ],
                cooldown: WorkoutStep(goal: .time(5, .minutes))
            )),
            id: UUID(uuidString: "6F1D5A3E-2B7C-4E8A-9D10-3C5B7A9E1F24")!
        )
        XCTAssertEqual(try plan("custom_workout.json"), expected)
    }

    func testSingleGoalWorkouts() throws {
        guard case let .goal(cycling) = try plan("single_goal_workout.json").workout else {
            return XCTFail("expected a single goal workout")
        }
        XCTAssertEqual(cycling, SingleGoalWorkout(activity: .cycling, location: .outdoor, goal: .energy(500, .kilocalories)))

        guard case let .goal(swim) = try plan("single_goal_swimming_workout.json").workout else {
            return XCTFail("expected a single goal workout")
        }
        XCTAssertEqual(swim, SingleGoalWorkout(activity: .swimming, swimmingLocation: .pool, goal: .distance(1000, .meters)))
    }

    func testPoolSwimDistanceWithTime() throws {
        guard #available(iOS 18.0, *) else {
            XCTAssertThrowsError(try plan("pool_swim_workout.json")) { error in
                XCTAssertEqual((error as? WorkoutkitError)?.code, "UNSUPPORTED_OS")
            }
            return
        }
        guard case let .custom(swim) = try plan("pool_swim_workout.json").workout else {
            return XCTFail("expected a custom workout")
        }
        XCTAssertEqual(swim, CustomWorkout(
            activity: .swimming,
            location: .indoor,
            displayName: "Pool Intervals",
            blocks: [IntervalBlock(steps: [
                IntervalStep(.work, goal: .poolSwimDistanceWithTime(
                    Measurement(value: 100, unit: .meters),
                    Measurement(value: 2, unit: .minutes)
                )),
                IntervalStep(.recovery, goal: .time(30, .seconds)),
            ], iterations: 4)]
        ))
    }

    func testUnsupportedCombinationsThrowInsteadOfTrapping() throws {
        // WorkoutKit's SingleGoalWorkout.init traps on this; we must throw.
        guard #available(iOS 18.0, *) else { throw XCTSkip("pool swim goals need iOS 18") }
        let json: [String: Any] = [
            "workoutType": "singleGoalWorkout",
            "activityType": "swimming",
            "swimmingLocation": "pool",
            "goal": ["type": "poolSwimDistanceWithTime", "targetValue": 1500, "unit": "meters", "targetDuration": 2400],
        ]
        XCTAssertThrowsError(try WorkoutPlanBuilder.plan(from: json)) { error in
            XCTAssertEqual((error as? WorkoutkitError)?.code, "UNSUPPORTED_WORKOUT")
        }

        var pacer = try Fixtures.object("pacer_workout.json")
        pacer["activityType"] = "archery"
        XCTAssertThrowsError(try WorkoutPlanBuilder.plan(from: pacer)) { error in
            XCTAssertEqual((error as? WorkoutkitError)?.code, "UNSUPPORTED_WORKOUT")
        }
    }

    func testPacerWorkout() throws {
        guard case let .pacer(pacer) = try plan("pacer_workout.json").workout else {
            return XCTFail("expected a pacer workout")
        }
        XCTAssertEqual(pacer, PacerWorkout(
            activity: .running,
            location: .outdoor,
            distance: Measurement(value: 5, unit: .kilometers),
            time: Measurement(value: 25, unit: .minutes)
        ))
    }

    func testSwimBikeRunWorkout() throws {
        guard case let .swimBikeRun(workout) = try plan("swim_bike_run_workout.json").workout else {
            return XCTFail("expected a swim bike run workout")
        }
        XCTAssertEqual(workout, SwimBikeRunWorkout(
            activities: [.swimming(.openWater), .cycling(.outdoor), .running(.outdoor)],
            displayName: "Sprint Triathlon"
        ))
    }

    func testGoals() throws {
        let built = try Fixtures.array("goals.json").map { try WorkoutBuilder.workoutGoal(JSONReader($0)) }
        XCTAssertEqual(built, [
            .open,
            .distance(5, .kilometers),
            .distance(400, .yards),
            .time(1.5, .minutes), // 90 s shown in minutes: not truncated to 1
            .time(2, .hours),
            .time(45, .seconds),
            .energy(250, .kilocalories),
            .energy(1000, .calories),
        ])
    }

    func testAlerts() throws {
        let built = try Fixtures.array("alerts.json").map { alert(try WorkoutBuilder.workoutAlert(JSONReader($0))) }
        var expected: [any WorkoutAlert] = [
            .heartRate(zone: 2),
            .heartRate(120...140),
            .cadence(80...95),
            .cadence(90),
            .power(zone: 3),
        ]
        if #available(iOS 17.4, *) {
            expected += [
                .power(200...250, unit: .watts, metric: .average),
                .power(230, unit: .watts, metric: .current),
            ] as [any WorkoutAlert]
        } else {
            expected += [.power(200...250, unit: .watts), .power(230, unit: .watts)] as [any WorkoutAlert]
        }
        expected += [
            .speed(28...32, unit: .kilometersPerHour, metric: .average),
            .speed(12, unit: .milesPerHour, metric: .current),
            // Pace alerts become speed alerts in m/s.
            .speed((1000.0 / 330.0)...(1000.0 / 300.0), unit: .metersPerSecond, metric: .current),
            .speed(1609.344 / 450.0, unit: .metersPerSecond, metric: .average),
        ] as [any WorkoutAlert]
        XCTAssertEqual(built, expected.map(alert))
    }

    func testPlanIdIsKeptOrGenerated() throws {
        XCTAssertEqual(try plan("custom_workout.json").id.uuidString, "6F1D5A3E-2B7C-4E8A-9D10-3C5B7A9E1F24")
        XCTAssertNotEqual(try plan("pacer_workout.json").id, try plan("pacer_workout.json").id)
    }

    // MARK: Invalid input throws instead of crashing

    private func assertInvalid(_ json: [String: Any], path: String, file: StaticString = #filePath, line: UInt = #line) {
        XCTAssertThrowsError(try WorkoutPlanBuilder.plan(from: json), file: file, line: line) { error in
            guard case let .invalidArgument(actualPath, _)? = error as? WorkoutkitError else {
                return XCTFail("unexpected error \(error)", file: file, line: line)
            }
            XCTAssertEqual(actualPath, path, file: file, line: line)
        }
    }

    func testInvalidInputThrows() throws {
        XCTAssertThrowsError(try WorkoutPlanBuilder.plan(from: nil))
        assertInvalid(["workoutType": "yoga"], path: "$.workoutType")
        assertInvalid(["workoutType": "pacerWorkout"], path: "$.activityType")

        var pacer = try Fixtures.object("pacer_workout.json")
        pacer["targetValue"] = "5"
        assertInvalid(pacer, path: "$.targetValue")

        pacer = try Fixtures.object("pacer_workout.json")
        pacer["id"] = "not-a-uuid"
        assertInvalid(pacer, path: "$.id")

        var single = try Fixtures.object("single_goal_workout.json")
        single["activityType"] = "quidditch"
        assertInvalid(single, path: "$.activityType")

        single = try Fixtures.object("single_goal_workout.json")
        single["goal"] = ["type": "distance", "targetValue": 5]
        assertInvalid(single, path: "$.goal.unit")
    }

    func testInvalidStepsAndAlertsThrow() throws {
        var custom = try Fixtures.object("custom_workout.json")
        custom["blocks"] = [["iterations": 1, "steps": [["purpose": "work"]]]]
        assertInvalid(custom, path: "$.blocks[0].steps[0]")

        custom["blocks"] = [["iterations": 1, "steps": [[
            "purpose": "work",
            "goal": ["type": "open"],
            "alert": ["type": "heartRateRange", "lowerBound": 170, "upperBound": 150],
        ]]]]
        assertInvalid(custom, path: "$.blocks[0].steps[0].alert.lowerBound")

        custom["blocks"] = [["iterations": 1, "steps": [[
            "purpose": "work",
            "goal": ["type": "open"],
            "alert": ["type": "heartRateZone"], // missing zone (old CadenceRangeAlert-style bug)
        ]]]]
        assertInvalid(custom, path: "$.blocks[0].steps[0].alert.zone")

        custom["blocks"] = [["iterations": 1, "steps": [[
            "purpose": "work",
            "goal": ["type": "open"],
            "alert": ["type": "telepathy"],
        ]]]]
        assertInvalid(custom, path: "$.blocks[0].steps[0].alert.type")
    }

    func testDeprecatedDanceMapsToCardioDance() throws {
        var single = try Fixtures.object("single_goal_workout.json")
        single["activityType"] = "dance"
        single["goal"] = ["type": "open"]
        single["location"] = "indoor"
        guard case let .goal(workout) = try WorkoutPlanBuilder.plan(from: single).workout else {
            return XCTFail("expected a single goal workout")
        }
        XCTAssertEqual(workout.activity, .cardioDance)
    }

    func testJSONReaderAcceptsIntsForDoublesButNotBools() throws {
        let reader = JSONReader(["a": 5, "b": 5.5, "c": true, "d": NSNull()])
        XCTAssertEqual(try reader.double("a"), 5)
        XCTAssertEqual(try reader.double("b"), 5.5)
        XCTAssertThrowsError(try reader.double("c"))
        XCTAssertNil(try reader.optionalDouble("d"))
        XCTAssertThrowsError(try reader.int("b"))
    }
}
