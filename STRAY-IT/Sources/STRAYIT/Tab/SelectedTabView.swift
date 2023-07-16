import Adventure
import Cheating
import ComposableArchitecture
import Direction
import SwiftUI

public struct SelectedTabView: View {
    private let store: StoreOf<CoreReducer>

    public init(store: StoreOf<CoreReducer>) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(store, observe: { $0 }, content: { viewStore in
            switch viewStore.state.tabSelection {
            case .direction:
                DirectionView(store: store.scope(state: \.direction, action: CoreReducer.Action.direction))

            case .adventure:
                AdventureView(store: store.scope(state: \.adventure, action: CoreReducer.Action.adventure))

            case .cheating:
                CheatingView(store: store.scope(state: \.cheating, action: CoreReducer.Action.cheating))
            }
        })
    }
}

public struct SelectedTabView_Previews: PreviewProvider {
    public static var previews: some View {
        SelectedTabView(store: Store(
            initialState: CoreReducer.State(),
            reducer: CoreReducer()
        ))
    }
}
