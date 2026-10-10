import SwiftUI
import UIKit
import WorkoutKit

/// Presents WorkoutKit's preview sheet without a native button, for
/// `WorkoutKit.presentPreview` in Dart.
///
/// WorkoutKit only offers the sheet as a SwiftUI modifier, so a transparent
/// hosting controller is presented full screen without animation; it shows
/// the sheet immediately and dismisses itself when the sheet closes.
@MainActor
final class WorkoutPreviewPresenter {
    private let topViewController: @MainActor () -> UIViewController?
    private var host: UIViewController?
    private var hostIsOnScreen = false
    private var finishRequested = false
    private var completion: (() -> Void)?

    /// Whether a preview is currently on screen.
    var isPresenting: Bool { host != nil }

    init(topViewController: @escaping @MainActor () -> UIViewController? = WorkoutPreviewPresenter.findTopViewController) {
        self.topViewController = topViewController
    }

    /// Presents the preview for `plan`. `completion` runs after the user
    /// dismissed the sheet.
    func present(_ plan: WorkoutPlan, completion: @escaping () -> Void) throws {
        guard host == nil else { throw WorkoutkitError.alreadyPresenting }
        guard let presenter = topViewController() else { throw WorkoutkitError.noPresenter }

        let hostController = UIHostingController(
            rootView: WorkoutPreviewHost(plan: plan) { [weak self] in self?.finish() }
        )
        hostController.view.backgroundColor = .clear
        hostController.modalPresentationStyle = .overFullScreen
        host = hostController
        self.completion = completion
        presenter.present(hostController, animated: false) { [weak self] in
            guard let self else { return }
            hostIsOnScreen = true
            if finishRequested { finish() }
        }
    }

    /// Tears down the host after the sheet closed and reports completion.
    /// The presenter stays busy until the host is gone; a call that arrives
    /// while the host is still being presented is deferred.
    func finish() {
        guard let host else { return }
        guard hostIsOnScreen else {
            finishRequested = true
            return
        }
        let completion = self.completion
        self.completion = nil
        let done = { [weak self] in
            self?.host = nil
            self?.hostIsOnScreen = false
            self?.finishRequested = false
            completion?()
        }
        if let presenting = host.presentingViewController {
            presenting.dismiss(animated: false, completion: done)
        } else {
            done()
        }
    }

    /// The topmost view controller of the foreground window scene.
    static func findTopViewController() -> UIViewController? {
        let scenes = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }
        let scene = scenes.first { $0.activationState == .foregroundActive } ?? scenes.first
        let window = scene?.windows.first { $0.isKeyWindow } ?? scene?.windows.first
        var top = window?.rootViewController
        while let presented = top?.presentedViewController, !presented.isBeingDismissed {
            top = presented
        }
        return top
    }
}

/// Invisible SwiftUI host that opens the preview sheet as soon as it appears.
struct WorkoutPreviewHost: View {
    let plan: WorkoutPlan
    let onDismiss: () -> Void
    @State private var isPresented = false

    var body: some View {
        Color.clear
            .ignoresSafeArea()
            .workoutPreview(plan, isPresented: $isPresented)
            .onAppear { isPresented = true }
            .onChange(of: isPresented) { _, presented in
                if !presented { onDismiss() }
            }
    }
}
