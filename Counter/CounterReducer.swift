import Foundation
import ComposableArchitecture
import PrimeModal

public enum CounterReducer {
    public static let reducer = combine(
        pullback(
            CounterReducer.reduce,
            value: \CounterViewState.count,
            action: \CounterViewAction.counter
        ),
        pullback(
            PrimeModalReducer.reduce,
            value: \.primeModalState,
            action: \.primeModel
        )
    )

    private static func reduce(state: inout Int, action: CounterAction) {
        switch action {
        case .decrementTapped: state -= 1
        case .incrementTapped: state += 1
        }
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
