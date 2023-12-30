import Foundation

public enum LoggingReducer {
    public static func reduce<Value, Action>(
        _ reducer: @escaping (inout Value, Action) -> Void
    ) -> (inout Value, Action) -> Void {
        return { value, action in
            reducer(&value, action)
            print("Action: \(action)")
            print("Value:")
            dump(value)
            print("--")
        }
    }
}
