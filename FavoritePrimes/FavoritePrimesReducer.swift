import Foundation
import ComposableArchitecture

public enum FavoritePrimesReducer {
    public static func reduce(
        state: inout [Int],
        action: FavoritePrimesAction
    ) -> [Effect<FavoritePrimesAction>] {
        switch action {
        case let .removeFavoritePrimes(indexSet):
            for index in indexSet {
                state.remove(at: index)
            }
            return []
        case let .loadedFavoritePrimes(primes):
            state = primes
            return []
        case .saveButtonTapped:
            let state = state
            return [{
                save(state)
                return nil
            }]
        case .loadButtonTapped:
            return [{
                let value = load()
                return .loadedFavoritePrimes(value)
            }]
        }
    }
    
    private static func save(_ value: [Int]) {
        let data = try! JSONEncoder().encode(value)
        let url = makeFavoritePrimesUrl()
        try! data.write(to: url)
    }

    private static func load() -> [Int] {
        let url = makeFavoritePrimesUrl()
        let data = try! Data(contentsOf: url)
        return try! JSONDecoder().decode([Int].self, from: data)
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
