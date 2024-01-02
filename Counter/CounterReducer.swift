import Foundation
import ComposableArchitecture
import PrimeModal

public struct CounterState {
    public var nthPrime: NthPrimeState?
    public var count: Int
    public var isNthPrimeButtonDisable: Bool

    public init(
        nthPrime: NthPrimeState? = nil,
        count: Int,
        isNthPrimeButtonDisable: Bool
    ) {
        self.nthPrime = nthPrime
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
            return [
                getNthPrimeFromRemote(state.count)
                    .map { .nthPrimeResponse($0) }
                    .receive(on: DispatchQueue.main)
            ]
        case let .nthPrimeResponse(prime):
            state.nthPrime = prime.map {
                NthPrimeState(prime: state.count, result: $0)
            }
            state.isNthPrimeButtonDisable = false
            return []
        case .nthPrimeDismissed:
            state.nthPrime = nil
            return []
        }
    }
}

func getNthPrimeFromRemote(_ n: Int) -> Effect<Int?> {
    return Effect { callback in
        DispatchQueue.global().asyncAfter(
            deadline: .now() + 0.3,
            execute: {
                callback(42)
            }
        )
    }
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
