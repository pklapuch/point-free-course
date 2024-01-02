import Foundation
import PrimeModal
import Counter
import FavoritePrimes
import ComposableArchitecture

private func noEffect() { }

enum ActivityFeedReducer {
    static func reduce(
        _ reducer: @escaping Reducer<AppState, AppAction>
    ) -> Reducer<AppState, AppAction> {
        return { value, action in
            var effect: Effect
            switch action {
            case let .counterView(action):
                effect = reduce(value: &value, action: action)
            case let .favoritePrimes(action):
                effect = reduce(value: &value, action: action)
            }

            let anotherEffect = reducer(&value, action)

            return {
                effect()
                anotherEffect()
            }
        }
    }

    private static func reduce(
        value: inout AppState,
        action: CounterViewAction
    ) -> Effect {
        switch action {
        case .counter:
            return noEffect
        case let .primeModal(action):
            return reduce(value: &value, action: action)
        }
    }

    private static func reduce(
        value: inout AppState,
        action: FavoritePrimesAction
    ) -> Effect {
        switch action {
        case let .removeFavoritePrimes(indexSet):
            removeFavoritePrimes(value: &value, indexSet: indexSet)
            return noEffect
        case .loadedFavoritePrimes:
            return noEffect
        case .saveButtonTapped:
            return noEffect
        }
    }

    private static func reduce(
        value: inout AppState,
        action: PrimeModalAction
    ) -> Effect {
        switch action {
        case .saveFavoritePrimeTapped:
            saveFavoritePrime(value: &value)
            return noEffect
        case .removeFavoritePrimeTapped:
            removeFavoritePrime(value: &value)
            return noEffect
        }
    }

    private static func removeFavoritePrime(value: inout AppState) {
        value.activityFeed.append(
            .init(timestamp: Date(), type: .removedFavoritePrime(value.count))
        )
    }

    private static func saveFavoritePrime(value: inout AppState) {
        value.activityFeed.append(
            .init(timestamp: Date(), type: .addedFavoritePrime(value.count))
        )
    }

    private static func removeFavoritePrimes(value: inout AppState, indexSet: IndexSet) {
        for index in indexSet {
            let prime = value.favoritePrimes[index]
            value.activityFeed.append(
                .init(timestamp: Date(), type: .removedFavoritePrime(prime))
            )
        }
    }
}
