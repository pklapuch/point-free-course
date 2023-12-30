import Foundation

public struct PrimeModalState {
    public let prime: Int
    public var favoritePrimes: [Int]

    public init(prime: Int, favoritePrimes: [Int]) {
        self.prime = prime
        self.favoritePrimes = favoritePrimes
    }
}
