import Foundation
import ComposableArchitecture

private func noEffect() { }

public enum PrimeModalReducer {
    public static func reduce(
        state: inout PrimeModalState,
        action: PrimeModalAction
    ) -> Effect {
        switch action {
        case .saveFavoritePrimeTapped:
            state.favoritePrimes.append(state.prime)
            return noEffect
        case .removeFavoritePrimeTapped:
            state.favoritePrimes.removeAll(where: { $0 == state.prime })
            return noEffect
        }
    }
}
