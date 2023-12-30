import Foundation

final class Store<Value, Action>: ObservableObject {
    typealias Reducer = (inout Value, Action) -> Void
    let reducer: Reducer
    @Published private(set) var value: Value

    init(
        initialValue: Value,
        reducer: @escaping Reducer
    ) {
        self.value = initialValue
        self.reducer = reducer
    }

    func send(_ action: Action) {
        reducer(&value, action)
    }
}
