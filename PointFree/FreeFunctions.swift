import Foundation

func ordinal(_ n: Int) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .ordinal
    return formatter.string(for: n) ?? ""
}

func isPrime(_ p: Int) -> Bool {
    if p <= 1 { return false }
    if p <= 3 { return true }

    for i in 2...Int(sqrtf(Float(p))) {
        if p % i == 0 { return false }
    }

    return true
}

func getNthPrimeFromRemote(_ n: Int, callback: @escaping (Int?) -> Void) {
    DispatchQueue.global().asyncAfter(
        deadline: .now() + 0.3,
        execute: { callback(42) }
    )
}
