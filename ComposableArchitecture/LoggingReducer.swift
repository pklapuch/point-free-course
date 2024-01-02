import Foundation

public enum LoggingReducer {
    public static func reduce<Value, Action>(
        _ reducer: @escaping Reducer<Value, Action>
    ) -> Reducer<Value, Action> {
        return { value, action in
            let effect = reducer(&value, action)
            let newValue = value
            
            return {
                print("Action: \(action)")
                print("Value:")
                dump(newValue)
                print("--")
                effect()
            }
        }
    }
}
