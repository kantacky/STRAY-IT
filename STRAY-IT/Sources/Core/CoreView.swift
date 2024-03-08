import ComposableArchitecture
import Navigation
import Search
import Launch
import Models
import SwiftUI
import Tutorial

public struct CoreView: View {
    private let store: StoreOf<Core>

    public init(store: StoreOf<Core>) {
        self.store = store
    }

    public var body: some View {
        Group {
            switch Core.Scene.scope(store.scope(state: \.scene, action: \.scene)) {
            case .launch:
                LaunchView()

            case let .tutorial(store):
                TutorialView(store: store)

            case let .search(store):
                SearchView(store: store)

            case let .navigation(store):
                StrayNavigationView(store: store)
            }
        }
        .onAppear { store.send(.onAppear) }
        .alert(store: store.scope(state: \.$alert, action: \.alert))
    }
}

#Preview {
    CoreView(store: Store(initialState: Core.State()) {
        Core()
    })
}
