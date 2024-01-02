import Foundation
import ComposableArchitecture

public enum PrimeModalReducer {
    public static func reduce(
        state: inout PrimeModalState,
        action: PrimeModalAction
    ) -> [Effect<PrimeModalAction>] {
        switch action {
        case .saveFavoritePrimeTapped:
            state.favoritePrimes.append(state.prime)
            return []
        case .removeFavoritePrimeTapped:
            state.favoritePrimes.removeAll(where: { $0 == state.prime })
            return []
        }
    }
}
