import Flutter
import Foundation

/// Errors surfaced to Dart as `WorkoutkitException`.
enum WorkoutkitError: Error, Equatable, CustomStringConvertible {
    /// A required field is missing or has the wrong type / value.
    case invalidArgument(path: String, expected: String)
    /// The feature needs a newer OS version.
    case unsupportedOS(feature: String, minimum: String)
    /// No scheduled workout matches the given id and date.
    case notFound(String)
    /// `dataRepresentation` / `init(from:)` failed.
    case serialization(String)
    /// WorkoutKit's `supports…` checks rejected the workout. WorkoutKit traps
    /// (crashes) when such a workout is constructed, so we check first.
    case unsupportedWorkout([String])

    var code: String {
        switch self {
        case .invalidArgument: return "INVALID_ARGUMENT"
        case .unsupportedOS: return "UNSUPPORTED_OS"
        case .notFound: return "NOT_FOUND"
        case .serialization: return "SERIALIZATION_ERROR"
        case .unsupportedWorkout: return "UNSUPPORTED_WORKOUT"
        }
    }

    var description: String {
        switch self {
        case let .invalidArgument(path, expected):
            return "Invalid value at '\(path)': expected \(expected)"
        case let .unsupportedOS(feature, minimum):
            return "\(feature) requires iOS \(minimum) or later"
        case let .notFound(message), let .serialization(message):
            return message
        case let .unsupportedWorkout(issues):
            return "Workout not supported by WorkoutKit: " + issues.joined(separator: "; ")
        }
    }

    var flutterError: FlutterError {
        if case let .unsupportedWorkout(issues) = self {
            return FlutterError(code: code, message: description, details: issues)
        }
        return FlutterError(code: code, message: description, details: nil)
    }

    /// The `{code, message}` payload used by the preview button channel.
    var dictionary: [String: String] {
        ["code": code, "message": description]
    }
}
