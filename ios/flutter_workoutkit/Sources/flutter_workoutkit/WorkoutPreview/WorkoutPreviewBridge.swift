@preconcurrency import Flutter
import SwiftUI
import UIKit
import WorkoutKit

/// Hosts `WorkoutPreviewButton` as a Flutter platform view.
///
/// Build errors are kept and handed to Dart through the per-view
/// `workout_preview_button_<id>` channel (`getBuildError`).
class WorkoutPreviewBridge: NSObject, FlutterPlatformView {
    private let hostingController: UIViewController
    private let channel: FlutterMethodChannel
    private let buildError: WorkoutkitError?

    init(frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?, messenger: FlutterBinaryMessenger) {
        let args = args as? [String: Any] ?? [:]
        let style = WorkoutPreviewButtonStyle(args)

        var plan: WorkoutPlan?
        var buildError: WorkoutkitError?
        do {
            plan = try WorkoutPlanBuilder.plan(from: args["workoutJson"])
        } catch {
            buildError = WorkoutkitError.from(error)
        }
        self.buildError = buildError

        // Flutter creates platform views on the main thread.
        let planBox = UncheckedSendable(plan)
        hostingController = MainActor.assumeIsolated {
            let root: AnyView
            if let plan = planBox.value {
                root = AnyView(
                    WorkoutPreviewButton(workoutPlan: plan, style: style)
                        .frame(maxWidth: .infinity, maxHeight: style.buttonHeight)
                )
            } else {
                root = AnyView(EmptyView())
            }
            let controller = UIHostingController(rootView: root)
            controller.view.backgroundColor = .clear
            return controller
        }

        channel = FlutterMethodChannel(name: "workout_preview_button_\(viewId)", binaryMessenger: messenger)
        super.init()

        channel.setMethodCallHandler { [weak self] call, result in
            guard call.method == "getBuildError" else {
                result(FlutterMethodNotImplemented)
                return
            }
            result(self?.buildError?.dictionary)
        }
    }

    deinit {
        channel.setMethodCallHandler(nil)
    }

    func view() -> UIView {
        let controller = UncheckedSendable(hostingController)
        return MainActor.assumeIsolated { controller.value.view }
    }
}

/// Styling options passed from the Dart widget.
struct WorkoutPreviewButtonStyle: Sendable {
    var buttonTitle = "Preview & Start Workout"
    var paddingHorizontal: CGFloat = 10
    var paddingVertical: CGFloat = 10
    var backgroundColor = Color.black
    var foregroundColor = Color.white
    var cornerRadiusSize: CGFloat = 8
    var buttonHeight: CGFloat = 50
    var fontSize: CGFloat = 16
    var fontWeight: Font.Weight = .semibold
    var sfSymbol: String?

    init(_ args: [String: Any]) {
        if let value = args["buttonTitle"] as? String { buttonTitle = value }
        if let value = args["paddingHorizontal"] as? NSNumber { paddingHorizontal = CGFloat(value.doubleValue) }
        if let value = args["paddingVertical"] as? NSNumber { paddingVertical = CGFloat(value.doubleValue) }
        if let value = args["backgroundColor"] as? NSNumber { backgroundColor = Color(UIColor(argb: value.uint32Value)) }
        if let value = args["foregroundColor"] as? NSNumber { foregroundColor = Color(UIColor(argb: value.uint32Value)) }
        if let value = args["cornerRadiusSize"] as? NSNumber { cornerRadiusSize = CGFloat(value.doubleValue) }
        if let value = args["buttonHeight"] as? NSNumber { buttonHeight = CGFloat(value.doubleValue) }
        if let value = args["fontSize"] as? NSNumber { fontSize = CGFloat(value.doubleValue) }
        if let value = args["sfSymbol"] as? String, !value.isEmpty { sfSymbol = value }
        if let value = args["fontWeight"] as? String {
            switch value.lowercased() {
            case "w100": fontWeight = .ultraLight
            case "w200": fontWeight = .thin
            case "w300": fontWeight = .light
            case "w400": fontWeight = .regular
            case "w500": fontWeight = .medium
            case "w600": fontWeight = .semibold
            case "w700": fontWeight = .bold
            case "w800": fontWeight = .heavy
            case "w900": fontWeight = .black
            default: fontWeight = .regular
            }
        }
    }
}

extension UIColor {
    /// Creates a color from a Flutter `Color.toARGB32()` value.
    convenience init(argb: UInt32) {
        self.init(
            red: CGFloat((argb >> 16) & 0xFF) / 255.0,
            green: CGFloat((argb >> 8) & 0xFF) / 255.0,
            blue: CGFloat(argb & 0xFF) / 255.0,
            alpha: CGFloat((argb >> 24) & 0xFF) / 255.0
        )
    }
}
