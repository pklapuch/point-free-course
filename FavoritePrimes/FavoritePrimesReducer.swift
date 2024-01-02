import Foundation
import ComposableArchitecture

private func noEffect() { }

public enum FavoritePrimesReducer {
    public static func reduce(
        state: inout [Int],
        action: FavoritePrimesAction
    ) -> Effect {
        switch action {
        case let .removeFavoritePrimes(indexSet):
            for index in indexSet {
                state.remove(at: index)
            }
            return noEffect
        case let .loadedFavoritePrimes(primes):
            state = primes
            return noEffect
        case .saveButtonTapped:
            let state = state
            return {
                save(state)
            }
        }
    }
    
    private static func save(_ value: [Int]) {
        let data = try! JSONEncoder().encode(value)
        let url = makeFavoritePrimesUrl()
        try! data.write(to: url)
    }

    private static func makeFavoritePrimesUrl() -> URL {
        let documentsPath = NSSearchPathForDirectoriesInDomains(
            .documentDirectory,
            .userDomainMask,
            true
        )[0]

        let documentsURL = URL(fileURLWithPath: documentsPath)

        return documentsURL.appendingPathComponent(
            "favorite-primes.json",
            conformingTo: .fileURL
        )
    }
}
