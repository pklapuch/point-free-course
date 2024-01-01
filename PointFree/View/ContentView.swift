import SwiftUI
import Combine
import FavoritePrimes
import Counter
import ComposableArchitecture

struct ContentView: View {
    @ObservedObject var store: Store<AppState, AppAction>

    var body: some View {
        NavigationView {
            List {
                NavigationLink(
                    destination: CounterView(
                        store: store.view(
                            value: { $0.counterView },
                            action: { .counterView($0) }
                        )
                    ), label: { Text("Counter Demo") }
                )
                NavigationLink(
                    destination: FavoritePrimesView(
                        store: store.view(
                            value: { $0.favoritePrimes },
                            action: { .favoritePrimes($0) }
                        )
                    ),
                    label: { Text("Favourites") }
                )
            }
            .navigationTitle("State Management")
        }
    }
}

#Preview {
    let store = Store<AppState, AppAction>(
        initialValue: AppState(),
        reducer: AppStateReducerComposer.reduce
    )

    return ContentView(store: store)
}
