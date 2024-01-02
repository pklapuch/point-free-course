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
            var counterEffects: [Effect<CounterViewAction>] = []
            var favoritePrimesEffects: [Effect<FavoritePrimesAction>] = []

            switch action {
            case let .counterView(action):
                counterEffects = reduce(value: &value, action: action)
            case let .favoritePrimes(action):
                favoritePrimesEffects = reduce(value: &value, action: action)
            }

            var allEffects = [Effect<AppAction>]()

            allEffects.append(contentsOf: counterEffects.map { counterEffect in
                Effect<AppAction> { callback in
                    counterEffect.run { localAction in
                        callback(.counterView(localAction))
                    }
                }
            })

            allEffects.append(contentsOf: favoritePrimesEffects.map { primeEffect in
                Effect<AppAction> { callback in
                    primeEffect.run { localAction in
                        callback(.favoritePrimes(localAction))
                    }
                }
            })

            let underlyingEffects = reducer(&value, action)
            allEffects.append(contentsOf: underlyingEffects)

            return allEffects
        }
    }

    private static func reduce(
        value: inout AppState,
        action: CounterViewAction
    ) -> [Effect<CounterViewAction>] {
        switch action {
        case .counter:
            return []
        case let .primeModal(action):
            let primeModalEffects = reduce(value: &value, action: action)
            
            return primeModalEffects.map { primeModalEffect in
                Effect<CounterViewAction>  { callback in
                    primeModalEffect.run { localAction in
                        callback(.primeModal(localAction))
                    }
                }
            }
        }
    }

    private static func reduce(
        value: inout AppState,
        action: FavoritePrimesAction
    ) -> [Effect<FavoritePrimesAction>] {
        switch action {
        case let .removeFavoritePrimes(indexSet):
            removeFavoritePrimes(value: &value, indexSet: indexSet)
            return []
        case .loadedFavoritePrimes:
            return []
        case .saveButtonTapped:
            return []
        case .loadButtonTapped:
            return []
        }
    }

    private static func reduce(
        value: inout AppState,
        action: PrimeModalAction
    ) -> [Effect<PrimeModalAction>] {
        switch action {
        case .saveFavoritePrimeTapped:
            saveFavoritePrime(value: &value)
            return []
        case .removeFavoritePrimeTapped:
            removeFavoritePrime(value: &value)
            return []
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
