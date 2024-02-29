import ComposableArchitecture
import Core
import SwiftUI

public struct AppRoot: App {
    private let store: StoreOf<Core>

    public init() {
        self.store = Store(initialState: Core.State()) {
            Core()
        }
    }

    public var body: some Scene {
        WindowGroup {
            CoreView(store: store)
        }
    }
}
