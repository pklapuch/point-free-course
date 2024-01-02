import Foundation

public func pullback<LocalValue, GlobalValue, LocalAction, GlobalAction>(
    _ reducer: @escaping Reducer<LocalValue, LocalAction>,
    value: WritableKeyPath<GlobalValue, LocalValue>,
    action: WritableKeyPath<GlobalAction, LocalAction?>
) -> Reducer<GlobalValue, GlobalAction> {
    return { globalValue, globalAction in
        guard let localAction = globalAction[keyPath: action] else { return }
        reducer(&globalValue[keyPath: value], localAction)
    }
}

public func combine<Value, Action>(
    _ reducers: Reducer<Value, Action>...
) -> Reducer<Value, Action> {
    return { value, action in
        reducers.forEach { $0(&value, action) }
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

        decorated(&value, action)
    }
}
