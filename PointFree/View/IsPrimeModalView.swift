import SwiftUI
import ComposableArchitecture

struct IsPrimeModalView: View {
    @ObservedObject var store: Store<AppState, AppAction>

    var body: some View {
        VStack {
            if isPrime(store.value.count) {
                Text("\(store.value.count) is prime!")

                if store.value.favoritePrimes.contains(store.value.count) {
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
                Text("\(store.value.count) is NOT prime!")
            }
        }
    }

    private func addFavorite() {
        store.send(.primeModal(.saveFavoritePrimeTapped))
    }

    private func removeFavorite() {
        store.send(.primeModal(.removeFavoritePrimeTapped))
    }
}
