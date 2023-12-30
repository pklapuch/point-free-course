import SwiftUI

struct FavoritePrimesView: View {
    @ObservedObject var store: Store<AppState, AppAction>

    var body: some View {
        List {
            ForEach(0..<store.value.favoritePrimes.count, id: \.self) { index in
                Text("\(store.value.favoritePrimes[index])")
            }
            .onDelete(perform: { indexSet in
                store.send(.favoritePrimes(.removeFavoritePrimes(indexSet)))
            })
        }
        .navigationTitle("Favorite Primes")
    }
}
