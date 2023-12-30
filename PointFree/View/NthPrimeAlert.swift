import SwiftUI

struct NthPrimeAlert: View {
    let state: AppState
    let result: Int

    var body: some View {
        Text("Nth prime of \(state.count) is: \(result)")
    }
}
