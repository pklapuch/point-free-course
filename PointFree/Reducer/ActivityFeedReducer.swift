import Foundation
import PrimeModal
import Counter
import FavoritePrimes

enum ActivityFeedReducer {
    static func reduce(
        _ reducer: @escaping (inout AppState, AppAction) -> Void
    ) -> (inout AppState, AppAction) -> Void {
        return { value, action in
            switch action {
            case let .counterView(action):
                reduce(value: &value, action: action)
            case let .favoritePrimes(action):
                reduce(value: &value, action: action)
            }

            reducer(&value, action)
        }
    }

    private static func reduce(value: inout AppState, action: CounterViewAction) {
        switch action {
        case .counter:
            break
        case let .primeModal(action):
            reduce(value: &value, action: action)
        }
    }

    private static func reduce(value: inout AppState, action: FavoritePrimesAction) {
        switch action {
        case let .removeFavoritePrimes(indexSet):
            removeFavoritePrimes(value: &value, indexSet: indexSet)
        }
    }

    private static func reduce(value: inout AppState, action: PrimeModalAction) {
        switch action {
        case .saveFavoritePrimeTapped:
            saveFavoritePrime(value: &value)
        case .removeFavoritePrimeTapped:
            removeFavoritePrime(value: &value)
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
