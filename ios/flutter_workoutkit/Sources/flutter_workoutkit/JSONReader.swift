import Foundation

/// Typed, throwing access to the JSON maps sent from Dart, so malformed input
/// becomes a `WorkoutkitError.invalidArgument` instead of a crash.
struct JSONReader {
    let json: [String: Any]
    let path: String

    init(_ json: [String: Any], path: String = "$") {
        self.json = json
        self.path = path
    }

    /// Accepts anything the platform channel or `JSONSerialization` produces.
    init(any value: Any?, path: String = "$") throws {
        guard let dict = value as? [String: Any] else {
            throw WorkoutkitError.invalidArgument(path: path, expected: "object")
        }
        self.init(dict, path: path)
    }

    private func keyPath(_ key: String) -> String { "\(path).\(key)" }

    private func value(_ key: String) -> Any? {
        guard let value = json[key], !(value is NSNull) else { return nil }
        return value
    }

    func has(_ key: String) -> Bool { value(key) != nil }

    func optionalString(_ key: String) throws -> String? {
        guard let raw = value(key) else { return nil }
        guard let string = raw as? String else {
            throw WorkoutkitError.invalidArgument(path: keyPath(key), expected: "string")
        }
        return string
    }

    func string(_ key: String) throws -> String {
        guard let string = try optionalString(key) else {
            throw WorkoutkitError.invalidArgument(path: keyPath(key), expected: "string")
        }
        return string
    }

    func optionalDouble(_ key: String) throws -> Double? {
        guard let raw = value(key) else { return nil }
        guard let number = raw as? NSNumber, CFGetTypeID(number) != CFBooleanGetTypeID() else {
            throw WorkoutkitError.invalidArgument(path: keyPath(key), expected: "number")
        }
        return number.doubleValue
    }

    func double(_ key: String) throws -> Double {
        guard let number = try optionalDouble(key) else {
            throw WorkoutkitError.invalidArgument(path: keyPath(key), expected: "number")
        }
        return number
    }

    func int(_ key: String) throws -> Int {
        let number = try double(key)
        guard number.rounded() == number else {
            throw WorkoutkitError.invalidArgument(path: keyPath(key), expected: "integer")
        }
        return Int(number)
    }

    func optionalBool(_ key: String) throws -> Bool? {
        guard let raw = value(key) else { return nil }
        guard let bool = raw as? Bool else {
            throw WorkoutkitError.invalidArgument(path: keyPath(key), expected: "bool")
        }
        return bool
    }

    func optionalObject(_ key: String) throws -> JSONReader? {
        guard let raw = value(key) else { return nil }
        return try JSONReader(any: raw, path: keyPath(key))
    }

    func object(_ key: String) throws -> JSONReader {
        guard let reader = try optionalObject(key) else {
            throw WorkoutkitError.invalidArgument(path: keyPath(key), expected: "object")
        }
        return reader
    }

    func objects(_ key: String) throws -> [JSONReader] {
        guard let array = value(key) as? [Any] else {
            throw WorkoutkitError.invalidArgument(path: keyPath(key), expected: "array")
        }
        return try array.enumerated().map { index, element in
            try JSONReader(any: element, path: "\(keyPath(key))[\(index)]")
        }
    }

    /// Reads a string and maps it through `table`, throwing on unknown values.
    func enumValue<T>(_ key: String, _ table: [String: T]) throws -> T {
        let raw = try string(key)
        guard let value = table[raw] else {
            throw WorkoutkitError.invalidArgument(
                path: keyPath(key),
                expected: "one of \(table.keys.sorted().joined(separator: ", "))"
            )
        }
        return value
    }

    func optionalEnumValue<T>(_ key: String, _ table: [String: T]) throws -> T? {
        has(key) ? try enumValue(key, table) : nil
    }
}
