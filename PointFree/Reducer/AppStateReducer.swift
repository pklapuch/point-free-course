import Foundation

enum AppStateReducer {
    static func reduce(
        state: inout AppState,
        action: AppAction
    ) {
        let appReducer: (inout AppState, AppAction) -> Void = combine(
            pullback(
                CounterReducer.reduce,
                value: \.count,
                action: \.counter
            ),
            pullback(
                PrimeModalReducer.reduce,
                value: \.self,
                action: \.primeModel
            ),
            pullback(
                FavoritePrimesReducer.reduce,
                value: \.favoritePrimes,
                action: \.favoritePrimes
            )
        )

        compose(reducer: appReducer, with:
            loggingReducer,
            activityFeedReducer
        )(&state, action)
    }
}

//extension AppState {
//    var favoritePrimesState: FavoritePrimesState {
//        get {
//            FavoritePrimesState(
//                favoritePrimes: favoritePrimes,
//                activityFeed: activityFeed
//            )
//        }
//        set {
//            favoritePrimes = newValue.favoritePrimes
//            activityFeed = newValue.activityFeed
//        }
//    }
//}

func compose<Value, Action>(
    reducer: @escaping (inout Value, Action) -> Void,
    with reducers: (@escaping (inout Value, Action) -> Void) -> (inout Value, Action) -> Void...
) -> (inout Value, Action) -> Void {
    return { value, action in
        guard !reducers.isEmpty else {
            reducer(&value, action)
            return
        }

        var decorated: (inout Value, Action) -> Void = { _, _ in }
        let ordered = Array(Array(reducers).reversed())

        for (index, decorator) in ordered.enumerated() {
            if index == 0 {
                decorated = decorator(reducer)
            } else {
                decorated = decorator(decorated)
            }
        }

        decorated(&value, action)
    }
}

func loggingReducer<Value, Action>(
    _ reducer: @escaping (inout Value, Action) -> Void
) -> (inout Value, Action) -> Void {
    return { value, action in
        reducer(&value, action)
        print("Action: \(action)")
        print("Value:")
        dump(value)
        print("--")
    }
}

func activityFeedReducer(
    _ reducer: @escaping (inout AppState, AppAction) -> Void
) -> (inout AppState, AppAction) -> Void {
    return { value, action in
        switch action {
        case .counter:
            break
        case .primeModal(.removeFavoritePrimeTapped):
            value.activityFeed.append(
                .init(timestamp: Date(), type: .removedFavoritePrime(value.count))
            )
        case .primeModal(.saveFavoritePrimeTapped): ()
            value.activityFeed.append(
                .init(timestamp: Date(), type: .addedFavoritePrime(value.count))
            )
        case let .favoritePrimes(.removeFavoritePrimes(indexSet)):
            for index in indexSet {
                let prime = value.favoritePrimes[index]
                value.activityFeed.append(
                    .init(timestamp: Date(), type: .removedFavoritePrime(prime))
                )
            }
        }

        reducer(&value, action)
    }
}

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
