import Foundation
import ComposableArchitecture
import FavoritePrimes
import Counter
import PrimeModal

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
                value: \.primeModalState,
                action: \.primeModel
            ),
            pullback(
                FavoritePrimesReducer.reduce,
                value: \.favoritePrimes,
                action: \.favoritePrimes
            )
        )

        compose(reducer: appReducer, with:
            LoggingReducer.reduce,
            ActivityFeedReducer.reduce
        )(&state, action)
    }
}

extension AppState {
    var primeModalState: PrimeModalState {
        get { PrimeModalState(prime: count, favoritePrimes: favoritePrimes) }
        set { favoritePrimes = newValue.favoritePrimes }
    }
}
