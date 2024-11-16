import UIKit
import SwiftUI

@available(iOS 17.0, *)
class WorkoutPreviewViewController: UIViewController {
    private var workoutJson: [String: Any]
    
    init(workoutJson: [String: Any]) {
        self.workoutJson = workoutJson
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() { 
        super.viewDidLoad()
        
        let swiftUIView = WorkoutPreviewButton(workoutJson: workoutJson)
        let hostingController = UIHostingController(rootView: swiftUIView)
        
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.view.frame = view.bounds
        hostingController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        hostingController.didMove(toParent: self)
    }
}