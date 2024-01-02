import Foundation
import ComposableArchitecture
import PrimeModal

public struct CounterState {
    public var alertNthPrime: NthPrimeAlert?
    public var count: Int
    public var isNthPrimeButtonDisable: Bool

    public init(
        alertNthPrime: NthPrimeAlert? = nil,
        count: Int,
        isNthPrimeButtonDisable: Bool
    ) {
        self.alertNthPrime = alertNthPrime
        self.count = count
        self.isNthPrimeButtonDisable = isNthPrimeButtonDisable
    }
}

public enum CounterReducer {
    public static let reducer = combine(
        pullback(
            CounterReducer.reduce,
            value: \CounterViewState.counter,
            action: \CounterViewAction.counter
        ),
        pullback(
            PrimeModalReducer.reduce,
            value: \.primeModalState,
            action: \.primeModel
        )
    )

    private static func reduce(
        state: inout CounterState,
        action: CounterAction
    ) -> [Effect<CounterAction>] {
        switch action {
        case .decrementTapped: 
            state.count -= 1
            return []
        case .incrementTapped:
            state.count += 1
            return []
        case .nthPrimeButtonTapped:
            state.isNthPrimeButtonDisable = true
            let count = state.count

            return [{
                getNthPrimeFromRemote(count) { prime in
                    // TODO:
                }
                return .nthPrimeResponse(1999)
            }]
        case let .nthPrimeResponse(prime):
            state.alertNthPrime = prime.map { 
                NthPrimeAlert(
                    prime: state.count,
                    result: $0
                )
            }
            state.isNthPrimeButtonDisable = false
            return []
        case .nthPrimeDismissed:
            state.alertNthPrime = nil
            return []
        }
    }
}

func getNthPrimeFromRemote(_ n: Int, callback: @escaping (Int?) -> Void) {
    DispatchQueue.global().asyncAfter(
        deadline: .now() + 0.3,
        execute: { callback(42) }
    )
}

private extension CounterViewState {
    var primeModalState: PrimeModalState {
        get {
            PrimeModalState(prime: count, favoritePrimes: favoritePrimes)
        }
        set {
            count = newValue.prime
            favoritePrimes = newValue.favoritePrimes
        }
    }
}
