import Foundation

public enum LoggingReducer {
    public static func reduce<Value, Action>(
        _ reducer: @escaping Reducer<Value, Action>
    ) -> Reducer<Value, Action> {
        return { value, action in
            let effects = reducer(&value, action)
            let newValue = value

            return [{ _ in
                print("Action: \(action)")
                print("Value:")
                dump(newValue)
                print("--")
            }] + effects
        }
    }
}
