import ComposableArchitecture
import ExtendedMKModels
import Search
import SharedModel
import SwiftUI
import Tutorial

public struct AppView: View {
    public typealias Reducer = AppReducer

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
                    if viewStore.state.search.goal != nil {
                        ComposedTabView(store: store)
                    } else {
                        SearchView(store: store.scope(state: \.search, action: AppReducer.Action.search))
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

public struct AppView_Previews: PreviewProvider {
    public static var previews: some View {
        AppView()
    }
}
