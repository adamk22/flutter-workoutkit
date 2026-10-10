/// Carries a value across a concurrency boundary that the compiler can't
/// prove safe. Only used for Flutter callbacks and values that are created
/// and consumed on the main thread.
struct UncheckedSendable<Value>: @unchecked Sendable {
    let value: Value

    init(_ value: Value) {
        self.value = value
    }
}
