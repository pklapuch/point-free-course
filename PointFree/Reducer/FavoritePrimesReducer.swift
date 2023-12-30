import Foundation

enum FavoritePrimesReducer {
    static func reduce(
        state: inout [Int],
        action: FavoritePrimesAction
    ) {
        switch action {
        case let .removeFavoritePrimes(indexSet):
            for index in indexSet {
                state.remove(at: index)
            }
        }
    }
}
