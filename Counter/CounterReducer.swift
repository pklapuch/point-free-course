import Foundation

public enum CounterReducer {
    public static func reduce(state: inout Int, action: CounterAction) {
        switch action {
        case .decrementTapped: state -= 1
        case .incrementTapped: state += 1
        }
    }
}
