import Foundation

enum LoggingReducer {
    static func reduce<Value, Action>(
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

final class AppStateLoggingReducer {
    static func reduce<AppState, AppAction>(
        _ reducer: @escaping (inout AppState, AppAction) -> Void
    ) -> (inout AppState, AppAction) -> Void {
        return { value, action in
            reducer(&value, action)
            // print as needed
        }
    }
}
