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
            return [saveEffect(favoritePrimes: state)]
        case .loadButtonTapped:
            return [loadEffect()]
        }
    }

    private static func saveEffect(
        favoritePrimes: [Int]
    ) -> Effect<FavoritePrimesAction> {
        {
            FileHelper.save(favoritePrimes)
            return nil
        }
    }

    private static func loadEffect(
    ) -> Effect<FavoritePrimesAction> {
        {
            let favoritePrimes = FileHelper.load()
            return .loadedFavoritePrimes(favoritePrimes)
        }
    }
}

enum FileHelper {
    static func save(_ value: [Int]) {
        let data = try! JSONEncoder().encode(value)
        let url = makeFavoritePrimesUrl()
        try! data.write(to: url)
    }

    static func load() -> [Int] {
        let url = makeFavoritePrimesUrl()
        let data = try! Data(contentsOf: url)
        return try! JSONDecoder().decode([Int].self, from: data)
    }

    static func makeFavoritePrimesUrl() -> URL {
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
