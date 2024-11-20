import Flutter
import UIKit
import SwiftUI
import WorkoutKit

@available(iOS 17.0, *)
class WorkoutPreviewBridge: NSObject, FlutterPlatformView {
    private var _view: UIView

    init(frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?, messenger: FlutterBinaryMessenger) {
        let workoutJson = (args as? [String: Any])?["workoutJson"] as? [String: Any] ?? [:]
        let buttonTitle = (args as? [String: Any])?["buttonTitle"] as? String ?? "Preview & Start Workout"
        let paddingHorizontal = (args as? [String: Any])?["paddingHorizontal"] as? CGFloat ?? 10
        let paddingVertical = (args as? [String: Any])?["paddingVertical"] as? CGFloat ?? 10
        let backgroundColor = {
            if let colorInt = (args as? [String: Any])?["backgroundColor"] as? Int {
                return Color(UIColor(rgb: UInt(colorInt)))
            }
            return Color.black
        }()
        let foregroundColor = {
            if let colorInt = (args as? [String: Any])?["foregroundColor"] as? Int {
                return Color(UIColor(rgb: UInt(colorInt)))
            }
            return Color.white
        }()
        let cornerRadiusSize = (args as? [String: Any])?["cornerRadiusSize"] as? CGFloat ?? 8
        let buttonHeight = (args as? [String: Any])?["buttonHeight"] as? CGFloat ?? 50
        let fontSize = (args as? [String: Any])?["fontSize"] as? CGFloat ?? 16
        let fontWeight: Font.Weight = {
            if let weightStr = (args as? [String: Any])?["fontWeight"] as? String {
                switch weightStr.lowercased() {
                case "w100": return .ultraLight
                case "w200": return .thin
                case "w300": return .light
                case "w400": return .regular
                case "w500": return .medium
                case "w600": return .semibold
                case "w700": return .bold
                case "w800": return .heavy
                case "w900": return .black
                default: return .regular
                }
            }
            return .semibold
        }()

        let hostingController = UIHostingController(
            rootView: WorkoutPreviewButton(workoutJson: workoutJson, buttonTitle: buttonTitle, paddingHorizontal: paddingHorizontal, paddingVertical: paddingVertical, backgroundColor: backgroundColor, foregroundColor: foregroundColor, cornerRadiusSize: cornerRadiusSize, buttonHeight: buttonHeight, fontSize: fontSize, fontWeight: fontWeight)
                .frame(maxWidth: .infinity, maxHeight: buttonHeight)
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

extension UIColor {
    convenience init(rgb: UInt) {
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: CGFloat((rgb & 0xFF000000) >> 24) / 255.0
        )
    }
}
