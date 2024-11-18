import SwiftUI
import WorkoutKit

@available(iOS 17.0, *)
struct WorkoutPreviewButton: View {
    @State private var showPreview = false
      let workoutPlan: WorkoutPlan
      let buttonTitle: String

      init(workoutJson: [String: Any], buttonTitle: String) {
          self.workoutPlan = WorkoutPlanBuilder.createWorkoutPlan(workoutJson: workoutJson)
          self.buttonTitle = buttonTitle
      }
      

      var body: some View {
          VStack {
            Button(action: {
                print("Button tapped")
                self.showPreview = true
            }) {
                Text(buttonTitle)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .frame(maxWidth: .infinity)
        .workoutPreview(workoutPlan, isPresented: $showPreview)
      }
  }