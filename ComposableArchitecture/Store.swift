import SwiftUI
import Combine

public typealias Parallel<Action> = (Action) -> Void
public typealias Effect<Action> = (@escaping Parallel<Action>) -> Void

public typealias Reducer<Value, Action> = (inout Value, Action) -> [Effect<Action>]

public final class Store<Value, Action>: ObservableObject {

    let reducer: Reducer<Value, Action>
    @Published public private(set) var value: Value
    private var cancellable: Cancellable?

    public init(
        initialValue: Value,
        reducer: @escaping Reducer<Value, Action>
    ) {
        self.value = initialValue
        self.reducer = reducer
    }

    public func send(_ action: Action) {
        reducer(&value, action)
            .forEach { effect in
                effect(self.send)
            }
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
                return []
            }
        )

        localStore.cancellable = self.$value.sink { [weak localStore] newValue in
            localStore?.value = toLocalValue(newValue)
        }

        return localStore
    }
}
