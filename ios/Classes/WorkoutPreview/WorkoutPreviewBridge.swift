import Flutter
import UIKit
import SwiftUI
import WorkoutKit

@available(iOS 17.0, *)
class WorkoutPreviewBridge: NSObject, FlutterPlatformView {
    private var _view: UIView

    init(frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?, messenger: FlutterBinaryMessenger) {
        let workoutJson = args as? [String: Any] ?? [:]
        let hostingController = UIHostingController(
            rootView: WorkoutPreviewButton(workoutJson: workoutJson)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        )
        
        _view = hostingController.view
        _view.backgroundColor = .clear
        super.init()

        if let parentViewController = UIApplication.shared.keyWindow?.rootViewController {
            parentViewController.addChild(hostingController)
            hostingController.didMove(toParent: parentViewController)
        }
    }

    func view() -> UIView {
        return _view
    }
}
