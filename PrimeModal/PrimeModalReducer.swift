import Foundation

public enum PrimeModalReducer {
    public static func reduce(
        state: inout PrimeModalState,
        action: PrimeModalAction
    ) {
        switch action {
        case .saveFavoritePrimeTapped:
            state.favoritePrimes.append(state.prime)
        case .removeFavoritePrimeTapped:
            state.favoritePrimes.removeAll(where: { $0 == state.prime })
        }
    }
}
