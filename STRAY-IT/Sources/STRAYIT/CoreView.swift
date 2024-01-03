import ComposableArchitecture
import Navigation
import Search
import Models
import SwiftUI
import Tutorial

struct CoreView: View {
    typealias Reducer = CoreReducer
    private let store: StoreOf<Reducer>
    @StateObject private var viewStore: ViewStoreOf<Reducer>

    init(store: StoreOf<Reducer>) {
        self.store = store
        self._viewStore = .init(wrappedValue: ViewStore(store, observe: { $0 }))
    }

    var body: some View {
            SwitchStore(store.scope(
                state: \.scene,
                action: { $0 }
            )) { state in
                switch state {
                case .launch:
                    LaunchView()

                case .tutorial:
                    CaseLet(/Reducer.State.Scene.tutorial, action: Reducer.Action.tutorial) { store in
                        TutorialView(store: store)
                    }

                case .search:
                    CaseLet(/Reducer.State.Scene.search, action: Reducer.Action.search) { store in
                        SearchView(store: store)
                    }

                case .navigation:
                    CaseLet(/Reducer.State.Scene.navigation, action: Reducer.Action.navigation) { store in
                        ComposedView(store: store)
                    }
                }
            }
            .onAppear {
                self.viewStore.send(.onAppear)
            }
            .alert(store: self.store.scope(state: \.$alert, action: \.alert))
    }
}

#Preview {
    CoreView(store: Store(
        initialState: CoreView.Reducer.State()
    ) {
        CoreView.Reducer()
    })
}
