import SwiftUI
import Combine

public final class Store<Value, Action>: ObservableObject {
    public typealias Reducer = (inout Value, Action) -> Void
    let reducer: Reducer
    @Published public private(set) var value: Value
    private var cancellable: Cancellable?

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

    public func view<LocalValue, LocalAction>(
        value toLocalValue: @escaping (Value) -> LocalValue,
        action toGlobalAction: @escaping (LocalAction) -> Action
    ) -> Store<LocalValue, LocalAction> {
        let localStore = Store<LocalValue, LocalAction>(
            initialValue: toLocalValue(value),
            reducer: { localValue, localAction in
                self.send(toGlobalAction(localAction))
                localValue = toLocalValue(self.value)
            }
        )

        localStore.cancellable = self.$value.sink { [weak localStore] newValue in
            localStore?.value = toLocalValue(newValue)
        }

        return localStore
    }
}
