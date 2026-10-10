import Flutter
import SwiftUI
import UIKit
import WorkoutKit
import XCTest

@testable import flutter_workoutkit

/// `WorkoutKit.presentPreview`: the transparent host that shows Apple's sheet.
@MainActor
final class PresenterTests: XCTestCase {
    private var window: UIWindow!
    private var root: UIViewController!

    override func setUp() async throws {
        try await super.setUp()
        let scene = try XCTUnwrap(
            UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }.first
        )
        root = UIViewController()
        window = UIWindow(windowScene: scene)
        window.rootViewController = root
        window.makeKeyAndVisible()
    }

    override func tearDown() async throws {
        // Tests leave nothing presented; this is only a safety net. (Waiting
        // here would block: async tearDown runs on the main queue itself.)
        root.presentedViewController?.dismiss(animated: false)
        window.isHidden = true
        window = nil
        root = nil
        try await super.tearDown()
    }

    /// Waits for UIKit's (asynchronous) presentation and dismissal.
    private func waitUntil(
        _ condition: @escaping () -> Bool,
        timeout: TimeInterval = 3,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let deadline = Date().addingTimeInterval(timeout)
        while !condition(), Date() < deadline {
            RunLoop.main.run(until: Date().addingTimeInterval(0.02))
        }
        XCTAssertTrue(condition(), "timed out", file: file, line: line)
    }

    private func plan() throws -> WorkoutPlan {
        try WorkoutPlanBuilder.plan(from: Fixtures.object("custom_workout.json"))
    }

    func testPresentsATransparentHostAndCompletesOnDismissal() throws {
        let presenter = WorkoutPreviewPresenter { [root] in root }
        var completed = false
        try presenter.present(try plan()) { completed = true }

        let host = try XCTUnwrap(root.presentedViewController)
        XCTAssertTrue(host is UIHostingController<WorkoutPreviewHost>)
        XCTAssertEqual(host.modalPresentationStyle, .overFullScreen)
        XCTAssertTrue(presenter.isPresenting)
        XCTAssertFalse(completed)

        // What the SwiftUI host calls when the sheet's binding turns false;
        // here it may arrive before UIKit finished presenting the host.
        presenter.finish()
        waitUntil { completed }
        XCTAssertFalse(presenter.isPresenting)
        XCTAssertNil(root.presentedViewController)
    }

    func testRejectsASecondPresentation() throws {
        let presenter = WorkoutPreviewPresenter { [root] in root }
        try presenter.present(try plan()) {}
        XCTAssertThrowsError(try presenter.present(try plan()) {}) { error in
            XCTAssertEqual(error as? WorkoutkitError, .alreadyPresenting)
        }
        // Still busy until the host is gone.
        presenter.finish()
        waitUntil { !presenter.isPresenting }
        XCTAssertNoThrow(try presenter.present(try plan()) {})
        presenter.finish()
        waitUntil { !presenter.isPresenting }
    }

    func testFailsWithoutAViewController() throws {
        let presenter = WorkoutPreviewPresenter { nil }
        XCTAssertThrowsError(try presenter.present(try plan()) {}) { error in
            XCTAssertEqual(error as? WorkoutkitError, .noPresenter)
        }
        XCTAssertFalse(presenter.isPresenting)
    }

    func testFindsTheTopmostPresentedViewController() {
        let modal = UIViewController()
        root.present(modal, animated: false)
        waitUntil { modal.presentingViewController != nil }
        XCTAssertTrue(WorkoutPreviewPresenter.findTopViewController() === modal)
        root.dismiss(animated: false)
        waitUntil { self.root.presentedViewController == nil }
    }

    func testPluginRejectsUnsupportedWorkoutsBeforePresenting() throws {
        var pacer = try Fixtures.object("pacer_workout.json")
        pacer["activityType"] = "archery"
        let error = invoke(WorkoutkitPlugin(), "presentPreview", pacer) as? FlutterError
        XCTAssertEqual(error?.code, "UNSUPPORTED_WORKOUT")
        XCTAssertNil(root.presentedViewController)
    }
}
