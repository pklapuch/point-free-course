import SwiftUI
import ComposableArchitecture
import PrimeModal

public typealias CounterViewState = (count: Int, favoritePrimes: [Int])

public enum CounterViewAction {
    case counter(CounterAction)
    case primeModal(PrimeModalAction)
}

public struct CounterView: View {
    @ObservedObject private var store: Store<CounterViewState, CounterViewAction>
    @State private var isPrimeModalShown: Bool = false
    @State private var nthPrime: Int?
    @State private var isNthPrimeShown: Bool = false
    @State private var isNthPrimeButtonDisabled = false

    public init(store: Store<CounterViewState, CounterViewAction>) {
        self.store = store
    }

    public var body: some View {
        VStack {
            HStack {
                Button(
                    action: { store.send(.counter(.decrementTapped)) },
                    label: { Text("-") }
                )

                Text("\(store.value.count)")

                Button(
                    action: { store.send(.counter(.incrementTapped)) },
                    label: { Text("+") }
                )
            }

            Button(
                action: { isPrimeModalShown = true },
                label: { Text("Is this prime?") }
            )

            Button(
                action: nthPrimeButtonAction,
                label: { Text("What is the \(ordinal(store.value.count)) prime?") }
            )
            .disabled(isNthPrimeButtonDisabled)
        }
        .font(.title)
        .navigationTitle("Counter Demo")
        .sheet(isPresented: $isPrimeModalShown, content: {
            IsPrimeModalView(
                store: store.view(
                    value: {
                        PrimeModalState(
                            prime: $0.count,
                            favoritePrimes: $0.favoritePrimes
                        )
                    },
                    action: { .primeModal($0) }
                )
            )
        })
        .alert(
            "Test",
            isPresented: $isNthPrimeShown, presenting: nthPrime) { nthPrime in
                VStack {
                    NthPrimeAlert(prime: store.value.count, result: nthPrime)
                    Button("OK", action: { isNthPrimeShown = false })
                }
        }
    }

    func nthPrimeButtonAction() {
        isNthPrimeButtonDisabled = true
        getNthPrimeFromRemote(store.value.count) { result in
            nthPrime = result
            isNthPrimeShown = true
            isNthPrimeButtonDisabled = false
        }
    }
}

func getNthPrimeFromRemote(_ n: Int, callback: @escaping (Int?) -> Void) {
    DispatchQueue.global().asyncAfter(
        deadline: .now() + 0.3,
        execute: { callback(42) }
    )
}

func ordinal(_ n: Int) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .ordinal
    return formatter.string(for: n) ?? ""
}

//#Preview {
//    let store = Store<AppState, AppAction>(
//        initialValue: AppState(),
//        reducer: AppStateReducerComposer.reduce
//    )
//
//    return CounterView(
//        store: store.view(
//            value: { ($0.count, $0.favoritePrimes) },
//            action: { $0 }
//        )
//    )
//}
