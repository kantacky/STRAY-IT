import ComposableArchitecture
import CoreLocation
import Search
import SharedModel
import SwiftUI
import Tutorial

public struct CoreView: View {
    public typealias Reducer = CoreReducer

    private let store: StoreOf<Reducer>
    @AppStorage("hasShownTutorial")
    private var hasShownTutorial: Bool = .init(false)
    @AppStorage("goal")
    private var goal: Data?

    public init() {
        self.store = Store(
            initialState: Reducer.State()
        ) {
            Reducer()
        }
    }

    public var body: some View {
        WithViewStore(self.store, observe: { $0 }, content: { viewStore in
            VStack(spacing: 0) {
                if self.goal == nil {
                    SearchView(store: store.scope(state: \.search, action: Reducer.Action.search))
                } else {
                    ComposedTabView(store: store)
                }
            }
            .overlay {
                if !hasShownTutorial {
                    TutorialView()
                }
            }
            .onAppear {
                viewStore.send(.onAppear)
            }
            .onDisappear {
                viewStore.send(.onDisappear)
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
