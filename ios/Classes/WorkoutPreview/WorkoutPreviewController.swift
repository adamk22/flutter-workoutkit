import UIKit
import SwiftUI

@available(iOS 17.0, *)
class WorkoutPreviewViewController: UIViewController {
    private var workoutJson: [String: Any]
    private var buttonTitle: String
    private var paddingHorizontal: CGFloat
    private var paddingVertical: CGFloat
    private var backgroundColor: Color
    private var foregroundColor: Color
    private var cornerRadiusSize: CGFloat
    private var buttonHeight: CGFloat
    private var fontSize: CGFloat
    private var fontWeight: Font.Weight

    init(workoutJson: [String: Any], buttonTitle: String, paddingHorizontal: CGFloat, paddingVertical: CGFloat, backgroundColor: Color, foregroundColor: Color, cornerRadiusSize: CGFloat, buttonHeight: CGFloat, fontSize: CGFloat, fontWeight: Font.Weight) {
        self.workoutJson = workoutJson
        self.buttonTitle = buttonTitle
        self.paddingHorizontal = paddingHorizontal
        self.paddingVertical = paddingVertical
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.cornerRadiusSize = cornerRadiusSize
        self.buttonHeight = buttonHeight
        self.fontSize = fontSize
        self.fontWeight = fontWeight
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() { 
        super.viewDidLoad()
        
        let swiftUIView = WorkoutPreviewButton(workoutJson: workoutJson, buttonTitle: buttonTitle, paddingHorizontal: paddingHorizontal, paddingVertical: paddingVertical, backgroundColor: backgroundColor, foregroundColor: foregroundColor, cornerRadiusSize: cornerRadiusSize, buttonHeight: buttonHeight, fontSize: fontSize, fontWeight: fontWeight)
        let hostingController = UIHostingController(rootView: swiftUIView)
        
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.view.frame = view.bounds
        hostingController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        hostingController.didMove(toParent: self)
    }
}
