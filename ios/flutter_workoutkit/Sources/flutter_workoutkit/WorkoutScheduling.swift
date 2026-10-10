import Foundation
import WorkoutKit

/// The parts of `WorkoutScheduler` the plugin uses, so tests can substitute a
/// fake (the real scheduler needs user authorization).
protocol WorkoutScheduling: AnyObject {
    var authorizationState: WorkoutScheduler.AuthorizationState { get async }
    func requestAuthorization() async -> WorkoutScheduler.AuthorizationState
    var scheduledWorkouts: [ScheduledWorkoutPlan] { get async }
    func schedule(_ workout: WorkoutPlan, at: DateComponents) async
    func remove(_ workout: WorkoutPlan, at: DateComponents) async
    func markComplete(_ workout: WorkoutPlan, at: DateComponents) async
    func removeAllWorkouts() async
}

extension WorkoutScheduler: WorkoutScheduling {}
