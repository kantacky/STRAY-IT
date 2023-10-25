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
    @AppStorage("hasShownTutorial")
    private var hasShownTutorial: Bool = .init(true)

    init(store: StoreOf<Reducer>) {
        self.store = store
        self._viewStore = .init(wrappedValue: ViewStore(store, observe: { $0 }))
    }

    var body: some View {
        if !self.hasShownTutorial {
            TutorialView()
        } else {
            SwitchStore(store.scope(
                state: \.status,
                action: { $0 }
            )) { state in
                switch state {
                case .search:
                    CaseLet(/Reducer.State.Status.search, action: Reducer.Action.search) { store in
                        SearchView(store: store)
                    }

                case .navigation:
                    CaseLet(/Reducer.State.Status.navigation, action: Reducer.Action.navigation) { store in
                        ComposedView(store: store)
                    }
                }
            }
            .onAppear { viewStore.send(.onAppear) }
            .alert(store: self.store.scope(state: \.$alert, action: { .alert($0) }))
        }
    }
}

#if DEBUG
#Preview {
    CoreView(store: Store(initialState: CoreView.Reducer.State(), reducer: { CoreView.Reducer() }))
}
#endif
