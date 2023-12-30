import Foundation

enum PrimeModalReducer {
    static func reduce(state: inout AppState, action: PrimeModalAction) {
        switch action {
        case .saveFavoritePrimeTapped:
            state.favoritePrimes.append(state.count)
        case .removeFavoritePrimeTapped:
            state.favoritePrimes.removeAll(where: { $0 == state.count })
        }
    }
}
