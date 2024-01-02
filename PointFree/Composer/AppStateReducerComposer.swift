import Foundation
import ComposableArchitecture
import FavoritePrimes
import Counter
import PrimeModal

enum AppStateReducerComposer {
    static func reduce(
        state: inout AppState,
        action: AppAction
    ) -> [Effect<AppAction>] {
        let appReducer: (inout AppState, AppAction) -> [Effect<AppAction>] = combine(
            pullback(
                CounterReducer.reducer,
                value: \.counterView,
                action: \.counterView
            ),
            pullback(
                FavoritePrimesReducer.reduce,
                value: \.favoritePrimes,
                action: \.favoritePrimes
            )
        )

        return compose(reducer: appReducer, with:
            LoggingReducer.reduce,
            ActivityFeedReducer.reduce
        )(&state, action)
    }
}

extension AppState {
    var counterView: CounterViewState {
        get {
            CounterViewState(
                alertNthPrime: alertNthPrime,
                count: count,
                favoritePrimes: favoritePrimes,
                isNthPrimeButtonDisable: isNthPrimeButtonDisable
            )
        }
        set {
            alertNthPrime = newValue.alertNthPrime
            count = newValue.count
            favoritePrimes = newValue.favoritePrimes
            isNthPrimeButtonDisable = newValue.isNthPrimeButtonDisable
        }
    }
}
