import Flutter
import Foundation

/// Errors surfaced to Dart as `WorkoutkitException`.
enum WorkoutkitError: Error, Equatable, CustomStringConvertible {
    /// A required field is missing or has the wrong type / value.
    case invalidArgument(path: String, expected: String)
    /// The feature needs a newer OS version. `path` points at the JSON
    /// element that uses it, when known.
    case unsupportedOS(feature: String, minimum: String, path: String? = nil)
    /// No scheduled workout matches the given id and date.
    case notFound(String)
    /// `dataRepresentation` / `init(from:)` failed.
    case serialization(String)
    /// WorkoutKit's `supports…` checks rejected the workout. WorkoutKit traps
    /// (crashes) when such a workout is constructed, so we check first.
    case unsupportedWorkout([ValidationIssue])
    /// `presentPreview` found no visible view controller to present from.
    case noPresenter
    /// `presentPreview` was called while a preview is already showing.
    case alreadyPresenting

    var code: String {
        switch self {
        case .invalidArgument: return "INVALID_ARGUMENT"
        case .unsupportedOS: return "UNSUPPORTED_OS"
        case .notFound: return "NOT_FOUND"
        case .serialization: return "SERIALIZATION_ERROR"
        case .unsupportedWorkout: return "UNSUPPORTED_WORKOUT"
        case .noPresenter: return "NO_PRESENTER"
        case .alreadyPresenting: return "ALREADY_PRESENTING"
        }
    }

    var description: String {
        switch self {
        case let .invalidArgument(path, expected):
            return "Invalid value at '\(path)': expected \(expected)"
        case let .unsupportedOS(feature, minimum, _):
            return "\(feature) requires iOS \(minimum) or later"
        case let .notFound(message), let .serialization(message):
            return message
        case .noPresenter:
            return "No visible view controller to present the workout preview from"
        case .alreadyPresenting:
            return "A workout preview is already being presented"
        case let .unsupportedWorkout(issues):
            return "Workout not supported by WorkoutKit: " + issues.map(\.message).joined(separator: "; ")
        }
    }

    var flutterError: FlutterError {
        switch self {
        case .unsupportedWorkout, .unsupportedOS:
            return FlutterError(code: code, message: description, details: validationIssues.map(\.dictionary))
        default:
            return FlutterError(code: code, message: description, details: nil)
        }
    }

    /// The error as validation issues, for `validate` and error details.
    var validationIssues: [ValidationIssue] {
        switch self {
        case let .unsupportedWorkout(issues):
            return issues
        case let .unsupportedOS(_, _, path):
            return [ValidationIssue(code: .unsupportedOS, path: path, message: description)]
        case let .invalidArgument(path, _):
            return [ValidationIssue(code: .invalidWorkout, path: Self.relative(path), message: description)]
        case .notFound, .serialization, .noPresenter, .alreadyPresenting:
            return [ValidationIssue(code: .invalidWorkout, path: nil, message: description)]
        }
    }

    /// Converts a JSON reader path (`$.blocks[0]`) to an issue path (`blocks[0]`).
    static func relative(_ path: String) -> String? {
        if path == "$" { return nil }
        return path.hasPrefix("$.") ? String(path.dropFirst(2)) : path
    }

    /// The `{code, message}` payload used by the preview button channel.
    var dictionary: [String: String] {
        ["code": code, "message": description]
    }
}
