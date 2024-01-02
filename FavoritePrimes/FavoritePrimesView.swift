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
        let data = try! JSONEncoder().encode(store.value)
        let url = makeFavoritePrimesUrl()
        try! data.write(to: url)
    }

    private func load() {
        let url = makeFavoritePrimesUrl()
        let data = try! Data(contentsOf: url)
        let value = try! JSONDecoder().decode([Int].self, from: data)
        store.send(.loadedFavoritePrimes(value))
    }

    private func makeFavoritePrimesUrl() -> URL {
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
