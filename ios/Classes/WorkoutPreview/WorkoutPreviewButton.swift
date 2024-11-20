import SwiftUI
import WorkoutKit

@available(iOS 17.0, *)
struct WorkoutPreviewButton: View {
    @State private var showPreview = false
    let workoutPlan: WorkoutPlan
    let buttonTitle: String
    let paddingHorizontal: CGFloat
    let paddingVertical: CGFloat
    let backgroundColor: Color
    let foregroundColor: Color
    let cornerRadiusSize: CGFloat
    let buttonHeight: CGFloat
    let fontSize: CGFloat
    let fontWeight: Font.Weight
    
    init(workoutJson: [String: Any], buttonTitle: String, paddingHorizontal: CGFloat, paddingVertical: CGFloat, backgroundColor: Color, foregroundColor: Color, cornerRadiusSize: CGFloat, buttonHeight: CGFloat, fontSize: CGFloat, fontWeight: Font.Weight) {
        self.workoutPlan = WorkoutPlanBuilder.createWorkoutPlan(workoutJson: workoutJson)
        self.buttonTitle = buttonTitle
        self.paddingHorizontal = paddingHorizontal
        self.paddingVertical = paddingVertical
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.cornerRadiusSize = cornerRadiusSize
        self.buttonHeight = buttonHeight
        self.fontSize = fontSize
        self.fontWeight = fontWeight
    }
    var body: some View {
        Button(action: {
            self.showPreview = true
        }) {                    
            HStack {
                Image(systemName: "apple.logo")
                    .foregroundColor(foregroundColor)
                    .font(.system(size: fontSize * 1.2))
                Text(buttonTitle)
                    .font(.system(size: fontSize, weight: fontWeight))
            }
            .frame(maxWidth: .infinity, maxHeight: buttonHeight)
            .padding(.horizontal, paddingHorizontal)
            .padding(.vertical, paddingVertical)
            .background(backgroundColor)
            .foregroundColor(foregroundColor)
            .cornerRadius(cornerRadiusSize)
        }
        .frame(maxWidth: .infinity, maxHeight: buttonHeight)
        .workoutPreview(workoutPlan, isPresented: $showPreview)
    }
}
