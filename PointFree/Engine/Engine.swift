import Foundation

func pullback<LocalValue, GlobalValue, LocalAction, GlobalAction>(
    _ reducer: @escaping (inout LocalValue, LocalAction) -> Void,
    value: WritableKeyPath<GlobalValue, LocalValue>,
    action: WritableKeyPath<GlobalAction, LocalAction?>
) -> (inout GlobalValue, GlobalAction) -> Void {
    return { globalValue, globalAction in
        guard let localAction = globalAction[keyPath: action] else { return }
        reducer(&globalValue[keyPath: value], localAction)
    }
}

func combine<Value, Action>(
    _ reducers: (inout Value, Action) -> Void...
) -> (inout Value, Action) -> Void {
    return { value, action in
        reducers.forEach { $0(&value, action) }
    }
}

func compose<Value, Action>(
    reducer: @escaping (inout Value, Action) -> Void,
    with reducers: (@escaping (inout Value, Action) -> Void) -> (inout Value, Action) -> Void...
) -> (inout Value, Action) -> Void {
    return { value, action in
        var decorated: (inout Value, Action) -> Void = reducer
        let reversedReducers = Array(Array(reducers).reversed())

        for decorator in reversedReducers {
            decorated = decorator(decorated)
        }

        decorated(&value, action)
    }
}
