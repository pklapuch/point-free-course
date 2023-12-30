import SwiftUI

public final class Store<Value, Action>: ObservableObject {
    public typealias Reducer = (inout Value, Action) -> Void
    let reducer: Reducer
    @Published public private(set) var value: Value

    public init(
        initialValue: Value,
        reducer: @escaping Reducer
    ) {
        self.value = initialValue
        self.reducer = reducer
    }

    public func send(_ action: Action) {
        reducer(&value, action)
    }
}
