import ComposableArchitecture
import Composed
import Search
import SharedModel
import SwiftUI
import Tutorial

public struct CoreView: View {
    public typealias Reducer = CoreReducer
    private let store: StoreOf<Reducer>
    @AppStorage("hasShownTutorial")
    private var hasShownTutorial: Bool = .init(false)

    public init() {
        self.store = Store(
            initialState: Reducer.State(),
            reducer: { Reducer() }
        )
    }

    public var body: some View {
        WithViewStore(self.store, observe: { $0 }, content: { viewStore in
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
            .overlay {
                if !self.hasShownTutorial {
                    TutorialView()
                }
            }
            .alert(
                item: viewStore.binding(
                    get: { $0.alert },
                    send: .alertDismissed
                ),
                content: {
                    Alert(title: Text($0.title), message: Text($0.message))
                }
            )
        })
    }
}

#Preview {
    CoreView()
}
