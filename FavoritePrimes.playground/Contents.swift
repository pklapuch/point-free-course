import SwiftUI
import ComposableArchitecture
import FavoritePrimes
import PlaygroundSupport

PlaygroundPage.current.liveView = UIHostingController(
    rootView: NavigationView {
        FavoritePrimesView(
            store: Store<[Int], FavoritePrimesAction>(
                initialValue: [2, 3, 4, 5],
                reducer: FavoritePrimesReducer.reduce
            )
        )
    }.frame(width: 300, height: 400)
)
