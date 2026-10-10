import Flutter
import WorkoutKit
import XCTest

@testable import flutter_workoutkit

/// Records scheduler calls in memory.
final class FakeScheduler: WorkoutScheduling {
    var state: WorkoutScheduler.AuthorizationState = .notDetermined
    var stateAfterRequest: WorkoutScheduler.AuthorizationState = .authorized
    var plans: [ScheduledWorkoutPlan] = []
    var completed: [(UUID, DateComponents)] = []

    var authorizationState: WorkoutScheduler.AuthorizationState {
        get async { state }
    }

    func requestAuthorization() async -> WorkoutScheduler.AuthorizationState {
        state = stateAfterRequest
        return state
    }

    var scheduledWorkouts: [ScheduledWorkoutPlan] {
        get async { plans }
    }

    func schedule(_ workout: WorkoutPlan, at date: DateComponents) async {
        plans.append(ScheduledWorkoutPlan(workout, date: date))
    }

    func remove(_ workout: WorkoutPlan, at date: DateComponents) async {
        plans.removeAll { $0.plan.id == workout.id && $0.date == date }
    }

    func markComplete(_ workout: WorkoutPlan, at date: DateComponents) async {
        completed.append((workout.id, date))
    }

    func removeAllWorkouts() async {
        plans.removeAll()
    }
}

final class SchedulerTests: XCTestCase {
    private var fake: FakeScheduler!
    private var plugin: WorkoutkitPlugin!
    private let date: [String: Any] = ["year": 2026, "month": 10, "day": 12, "hour": 7, "minute": 30]

    override func setUp() {
        super.setUp()
        fake = FakeScheduler()
        plugin = WorkoutkitPlugin(scheduler: fake, schedulerIsSupported: { true }, maxAllowedScheduledWorkoutCount: 15)
    }

    private func schedule(_ fixture: String = "custom_workout.json") throws -> [String: Any] {
        let result = invoke(plugin, "scheduler.schedule", ["workout": try Fixtures.object(fixture), "date": date])
        return try XCTUnwrap(result as? [String: Any], "\(String(describing: result))")
    }

    func testStaticQueries() {
        XCTAssertEqual(invoke(plugin, "scheduler.isSupported") as? Bool, true)
        XCTAssertEqual(invoke(plugin, "scheduler.maxAllowedScheduledWorkoutCount") as? Int, 15)
    }

    func testAuthorizationStatesMapToDartNames() {
        let names: [(WorkoutScheduler.AuthorizationState, String)] = [
            (.notDetermined, "notDetermined"), (.restricted, "restricted"),
            (.denied, "denied"), (.authorized, "authorized"),
        ]
        for (state, name) in names {
            fake.state = state
            XCTAssertEqual(invoke(plugin, "scheduler.authorizationState") as? String, name)
            fake.stateAfterRequest = state
            XCTAssertEqual(invoke(plugin, "scheduler.requestAuthorization") as? String, name)
        }
    }

    func testScheduleReturnsTheScheduledWorkout() throws {
        let scheduled = try schedule()
        let workout = try XCTUnwrap(scheduled["workout"] as? [String: Any])
        XCTAssertEqual(workout["id"] as? String, "6F1D5A3E-2B7C-4E8A-9D10-3C5B7A9E1F24")
        XCTAssertEqual(scheduled["date"] as? [String: Int], date as? [String: Int])
        XCTAssertEqual(scheduled["complete"] as? Bool, false)

        XCTAssertEqual(fake.plans.count, 1)
        XCTAssertEqual(SchedulerDate.json(fake.plans[0].date), date as? [String: Int])

        let listed = try XCTUnwrap(invoke(plugin, "scheduler.scheduledWorkouts") as? [[String: Any]])
        XCTAssertEqual(listed.count, 1)
        XCTAssertEqual((listed[0]["workout"] as? [String: Any])?["displayName"] as? String, "Intervals")
    }

    func testScheduledWorkoutsGetAnIdWhenNoneIsGiven() throws {
        let scheduled = try schedule("pacer_workout.json")
        let id = try XCTUnwrap((scheduled["workout"] as? [String: Any])?["id"] as? String)
        XCTAssertNotNil(UUID(uuidString: id))
        XCTAssertEqual(fake.plans.first?.plan.id.uuidString, id)
    }

    func testMarkCompleteAndRemoveFindThePlanByIdAndDate() throws {
        _ = try schedule()
        let id = "6f1d5a3e-2b7c-4e8a-9d10-3c5b7a9e1f24" // ids match case-insensitively

        XCTAssertNil(invoke(plugin, "scheduler.markComplete", ["id": id, "date": date]))
        XCTAssertEqual(fake.completed.count, 1)

        var otherDate = date
        otherDate["minute"] = 31
        let wrongDate = invoke(plugin, "scheduler.remove", ["id": id, "date": otherDate]) as? FlutterError
        XCTAssertEqual(wrongDate?.code, "NOT_FOUND")
        XCTAssertEqual(fake.plans.count, 1)

        XCTAssertNil(invoke(plugin, "scheduler.remove", ["id": id, "date": date]))
        XCTAssertTrue(fake.plans.isEmpty)

        let again = invoke(plugin, "scheduler.remove", ["id": id, "date": date]) as? FlutterError
        XCTAssertEqual(again?.code, "NOT_FOUND")
    }

    func testRemoveAll() throws {
        _ = try schedule()
        _ = try schedule("pacer_workout.json")
        XCTAssertEqual(fake.plans.count, 2)
        XCTAssertNil(invoke(plugin, "scheduler.removeAll"))
        XCTAssertTrue(fake.plans.isEmpty)
    }

    func testInvalidInputIsRejectedBeforeScheduling() throws {
        var badDate = date
        badDate["month"] = 2
        badDate["day"] = 31
        let invalidDate = invoke(plugin, "scheduler.schedule", ["workout": try Fixtures.object("pacer_workout.json"), "date": badDate])
        XCTAssertEqual((invalidDate as? FlutterError)?.code, "INVALID_ARGUMENT")

        var unsupported = try Fixtures.object("pacer_workout.json")
        unsupported["activityType"] = "archery"
        let rejected = invoke(plugin, "scheduler.schedule", ["workout": unsupported, "date": date]) as? FlutterError
        XCTAssertEqual(rejected?.code, "UNSUPPORTED_WORKOUT")
        let details = try XCTUnwrap(rejected?.details as? [[String: Any]])
        XCTAssertEqual(details.count, 1)
        XCTAssertEqual(details.first?["code"] as? String, "unsupportedActivity")
        XCTAssertEqual(details.first?["path"] as? String, "activityType")

        XCTAssertTrue(fake.plans.isEmpty)
    }
}
