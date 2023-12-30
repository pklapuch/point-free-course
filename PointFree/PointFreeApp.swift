import SwiftUI
import ComposableArchitecture

@main
struct PointFreeApp: App {
    var body: some Scene {
        WindowGroup {
            let store = Store<AppState, AppAction>(
                initialValue: AppState(),
                reducer: AppStateReducerComposer.reduce
            )

            ContentView(store: store)
        }
    }
}
