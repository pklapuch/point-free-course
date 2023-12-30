import SwiftUI
import Combine
import ComposableArchitecture

struct ContentView: View {
    @ObservedObject var store: Store<AppState, AppAction>

    var body: some View {
        NavigationView {
            List {
                NavigationLink(
                    destination: CounterView(store: store), label: { Text("Counter Demo") }
                )
                NavigationLink(
                    destination: FavoritePrimesView(store: store),
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
