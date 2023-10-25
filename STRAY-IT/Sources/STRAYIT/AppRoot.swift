import ComposableArchitecture
import SwiftUI

public struct AppRoot: App {
    private typealias Reducer = CoreReducer
    private let store: StoreOf<Reducer>

    public init() {
        self.store = Store(initialState: Reducer.State(), reducer: { Reducer() })
    }

    public var body: some Scene {
        WindowGroup {
            CoreView(store: self.store)
        }
    }
}
