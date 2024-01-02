import SwiftUI
import ComposableArchitecture

public struct FavoritePrimesView: View {
    @ObservedObject var store: Store<[Int], FavoritePrimesAction>

    public init(store: Store<[Int], FavoritePrimesAction>) {
        self.store = store
    }

    public var body: some View {
        List {
            ForEach(0..<store.value.count, id: \.self) { index in
                Text("\(store.value[index])")
            }
            .onDelete(perform: { indexSet in
                store.send(.removeFavoritePrimes(indexSet))
            })
        }
        .navigationTitle("Favorite Primes")
        .navigationBarItems(
            trailing: HStack {
                Button(action: save, label: { Text("Save") })
                Button(action: load, label: { Text("Load") })
            }
        )
    }

    private func save() {
        store.send(.saveButtonTapped)
    }

    private func load() {
        store.send(.loadButtonTapped)
    }
}
