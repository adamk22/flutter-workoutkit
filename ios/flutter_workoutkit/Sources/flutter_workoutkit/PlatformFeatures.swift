import Foundation
import WorkoutKit

/// OS-dependent WorkoutKit features. The builders consult `current` in
/// addition to `#available`, so tests can simulate older iOS versions on a
/// newer simulator.
struct PlatformFeatures: Equatable, Sendable {
    /// `WorkoutStep.displayName` (iOS 18).
    var stepDisplayName: Bool
    /// `WorkoutGoal.poolSwimDistanceWithTime` (iOS 18).
    var poolSwimGoal: Bool
    /// `metric:` on power alerts (iOS 17.4).
    var powerAlertMetric: Bool

    static var system: PlatformFeatures {
        var features = PlatformFeatures(stepDisplayName: false, poolSwimGoal: false, powerAlertMetric: false)
        if #available(iOS 18.0, *) {
            features.stepDisplayName = true
            features.poolSwimGoal = true
        }
        if #available(iOS 17.4, *) {
            features.powerAlertMetric = true
        }
        return features
    }

    /// iOS 17.0–17.3.
    static let iOS17_0 = PlatformFeatures(stepDisplayName: false, poolSwimGoal: false, powerAlertMetric: false)

    /// The features the builders use. Tests override it for a scope with
    /// `PlatformFeatures.$current.withValue(.iOS17_0) { ... }`.
    @TaskLocal static var current = PlatformFeatures.system
}
