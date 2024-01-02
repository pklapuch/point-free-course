import SwiftUI

public struct NthPrimeAlert: View, Identifiable {
    public var id: String
    public let state: NthPrimeState

    public init(state: NthPrimeState) {
        self.state = state
        self.id = UUID().uuidString
    }

    public var body: some View {
        Text("Nth prime of \(state.prime) is: \(state.result)")
    }
}
