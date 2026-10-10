import SwiftUI
import WorkoutKit

/// A button that presents WorkoutKit's preview sheet for `workoutPlan`.
struct WorkoutPreviewButton: View {
    @State private var showPreview = false
    let workoutPlan: WorkoutPlan
    let style: WorkoutPreviewButtonStyle

    var body: some View {
        Button {
            showPreview = true
        } label: {
            HStack {
                if let symbol = style.sfSymbol {
                    Image(systemName: symbol)
                        .font(.system(size: style.fontSize * 1.2))
                }
                Text(style.buttonTitle)
                    .font(.system(size: style.fontSize, weight: style.fontWeight))
            }
            .frame(maxWidth: .infinity, maxHeight: style.buttonHeight)
            .padding(.horizontal, style.paddingHorizontal)
            .padding(.vertical, style.paddingVertical)
            .background(style.backgroundColor)
            .foregroundColor(style.foregroundColor)
            .cornerRadius(style.cornerRadiusSize)
        }
        .frame(maxWidth: .infinity, maxHeight: style.buttonHeight)
        .workoutPreview(workoutPlan, isPresented: $showPreview)
    }
}
