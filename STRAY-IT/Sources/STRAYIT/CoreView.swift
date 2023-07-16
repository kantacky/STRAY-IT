import ComposableArchitecture
import Search
import SwiftUI
import Tutorial

public struct CoreView: View {
    public typealias Reducer = CoreReducer

    private let store: StoreOf<Reducer>
    @AppStorage("hasShownTutorial")
    private var hasShownTutorial: Bool = .init(false)

    public init() {
        self.store = Store(initialState: Reducer.State(), reducer: Reducer())
    }

    public var body: some View {
        WithViewStore(self.store, observe: { $0 }, content: { viewStore in
            VStack(spacing: 0) {
                if hasShownTutorial {
                    if viewStore.state.search.goal == nil {
                        SearchView(store: store.scope(state: \.search, action: Reducer.Action.search))
                    } else {
                        ComposedTabView(store: store)
                            .onAppear {
                                viewStore.send(.setStartAndGoal)
                            }
                    }
                } else {
                    TutorialView()
                }
            }
            .onAppear {
                viewStore.send(.onAppear)
            }
            .onDisappear {
                viewStore.send(.onDisappear)
            }
        })
    }
}

#Preview {
    CoreView()
}
