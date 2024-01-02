import Foundation

public enum LoggingReducer {
    public static func reduce<Value, Action>(
        _ reducer: @escaping Reducer<Value, Action>
    ) -> Reducer<Value, Action> {
        return { value, action in
            reducer(&value, action)
            print("Action: \(action)")
            print("Value:")
            dump(value)
            print("--")
        }
    }
}
