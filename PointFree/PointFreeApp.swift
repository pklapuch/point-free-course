//
//  PointFreeApp.swift
//  PointFree
//
//  Created by Pawel Klapuch on 12/29/23.
//

import SwiftUI

@main
struct PointFreeApp: App {
    var body: some Scene {
        WindowGroup {
            let store = Store<AppState, AppAction>(
                initialValue: AppState(),
                reducer: AppStateReducer.reduce
            )

            ContentView(store: store)
        }
    }
}
