import Foundation

public enum FavoritePrimesReducer {
    public static func reduce(
        state: inout [Int],
        action: FavoritePrimesAction
    ) {
        switch action {
        case let .removeFavoritePrimes(indexSet):
            for index in indexSet {
                state.remove(at: index)
            }
        case let .loadedFavoritePrimes(primes):
            state = primes
        case .saveButtonTapped:
            save(state)
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
