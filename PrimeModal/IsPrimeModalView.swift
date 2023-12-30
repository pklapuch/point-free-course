import SwiftUI
import ComposableArchitecture

public struct IsPrimeModalView: View {
    @ObservedObject var store: Store<PrimeModalState, PrimeModalAction>

    public init(store: Store<PrimeModalState, PrimeModalAction>) {
        self.store = store
    }

    public var body: some View {
        VStack {
            if isPrime(store.value.prime) {
                Text("\(store.value.prime) is prime!")

                if store.value.favoritePrimes.contains(store.value.prime) {
                    Button(
                        action: removeFavorite,
                        label: { Text("Remove from favorite primes")  }
                    )
                } else {
                    Button(
                        action: addFavorite,
                        label: { Text("Save to favorite primes")  }
                    )
                }

            } else {
                Text("\(store.value.prime) is NOT prime!")
            }
        }
    }

    private func addFavorite() {
        store.send(.saveFavoritePrimeTapped)
    }

    private func removeFavorite() {
        store.send(.removeFavoritePrimeTapped)
    }
}

func isPrime(_ p: Int) -> Bool {
    if p <= 1 { return false }
    if p <= 3 { return true }

    for i in 2...Int(sqrtf(Float(p))) {
        if p % i == 0 { return false }
    }

    return true
}

