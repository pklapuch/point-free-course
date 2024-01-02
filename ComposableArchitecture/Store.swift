import SwiftUI
import Combine

public struct Effect<A> {
    public let run: (@escaping (A) -> Void) -> Void

    public init(run: @escaping (@escaping (A) -> Void) -> Void) {
        self.run = run
    }

    public func map<B>(_ f: @escaping (A) -> B) -> Effect<B> {
        return Effect<B> { callback in
            self.run { a in callback(f(a)) }
        }
    }
}

public extension Effect {
    func receive(on queue: DispatchQueue) -> Effect {
        return Effect { callback in
            self.run { a in
                queue.async {
                    callback(a)
                }
            }
        }
    }
}

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
                effect.run(self.send)
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
