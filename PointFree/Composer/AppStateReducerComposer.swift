import Foundation

enum AppStateReducerComposer {
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
            AppStateLoggingReducer.reduce,
            LoggingReducer.reduce,
            ActivityFeedReducer.reduce
        )(&state, action)
    }
}
