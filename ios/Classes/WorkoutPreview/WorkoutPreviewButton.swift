import SwiftUI
import WorkoutKit

@available(iOS 17.0, *)
struct WorkoutPreviewButton: View {
    @State private var showPreview = false
      let workoutPlan: WorkoutPlan

      init(workoutJson: [String: Any]) {
          self.workoutPlan = WorkoutPlanBuilder.createWorkoutPlan(workoutJson: workoutJson)
          print("workoutJson: \(workoutJson)")
      }
      

      var body: some View {
          VStack {
            Button(action: {
                print("Button tapped")
                self.showPreview = true
            }) {
                Text("Preview Workout")
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