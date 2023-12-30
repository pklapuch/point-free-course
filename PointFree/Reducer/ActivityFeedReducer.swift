import Foundation

enum ActivityFeedReducer {
    static func reduce(
        _ reducer: @escaping (inout AppState, AppAction) -> Void
    ) -> (inout AppState, AppAction) -> Void {
        return { value, action in
            switch action {
            case .primeModal(.removeFavoritePrimeTapped):
                removeFavoritePrime(value: &value)
            case .primeModal(.saveFavoritePrimeTapped): ()
                saveFavoritePrime(value: &value)
            case let .favoritePrimes(.removeFavoritePrimes(indexSet)):
                removeFavoritePrimes(value: &value, indexSet: indexSet)
            default:
                ()
            }

            reducer(&value, action)
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
