import SwiftUI

struct NthPrimeAlert: View {
    let prime: Int
    let result: Int

    var body: some View {
        Text("Nth prime of \(prime) is: \(result)")
    }
}
