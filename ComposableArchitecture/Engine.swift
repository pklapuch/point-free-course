import Foundation

public func pullback<LocalValue, GlobalValue, LocalAction, GlobalAction>(
    _ reducer: @escaping Reducer<LocalValue, LocalAction>,
    value: WritableKeyPath<GlobalValue, LocalValue>,
    action: WritableKeyPath<GlobalAction, LocalAction?>
) -> Reducer<GlobalValue, GlobalAction> {
    return { globalValue, globalAction in
        guard let localAction = globalAction[keyPath: action] else {
            return []
        }

        let localEffects = reducer(&globalValue[keyPath: value], localAction)

        return localEffects.map { localEffect in
            Effect { callback in
                localEffect.run { localAction in
                    var globalAction = globalAction
                    globalAction[keyPath: action] = localAction
                    callback(globalAction)
                }
            }
        }
    }
}

public func combine<Value, Action>(
    _ reducers: Reducer<Value, Action>...
) -> Reducer<Value, Action> {
    return { value, action in
        let effects = reducers.flatMap { $0(&value, action) }
        return effects
    }
}

public func compose<Value, Action>(
    reducer: @escaping Reducer<Value, Action>,
    with reducers: (@escaping Reducer<Value, Action>) -> Reducer<Value, Action>...
) -> Reducer<Value, Action> {
    return { value, action in
        var decorated: Reducer<Value, Action> = reducer
        let reversedReducers = Array(Array(reducers).reversed())

        for decorator in reversedReducers {
            decorated = decorator(decorated)
        }

        return decorated(&value, action)
    }
}
