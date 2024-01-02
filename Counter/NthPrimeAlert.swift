import SwiftUI

public struct NthPrimeAlert: View, Identifiable {
    public var id: String

    public let prime: Int
    public let result: Int

    public init(prime: Int, result: Int) {
        self.prime = prime
        self.result = result
        self.id = UUID().uuidString
    }

    public var body: some View {
        Text("Nth prime of \(prime) is: \(result)")
    }
}
