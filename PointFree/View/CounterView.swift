import SwiftUI

struct CounterView: View {
    @ObservedObject var store: Store<AppState, AppAction>
    @State var isPrimeModalShown: Bool = false
    @State var nthPrime: Int?
    @State var isNthPrimeShown: Bool = false
    @State var isNthPrimeButtonDisabled = false

    var body: some View {
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
            IsPrimeModalView(store: store)
        })
        .alert(
            "Test",
            isPresented: $isNthPrimeShown, presenting: nthPrime) { nthPrime in
                VStack {
                    NthPrimeAlert(state: store.value, result: nthPrime)
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

#Preview {
    let store = Store<AppState, AppAction>(
        initialValue: AppState(),
        reducer: AppStateReducerComposer.reduce
    )

    return CounterView(store: store)
}
