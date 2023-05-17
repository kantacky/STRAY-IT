import Adventure
import Cheating
import ComposableArchitecture
import Direction
import SwiftUI

public struct SelectedTabView: View {
    private let store: StoreOf<AppReducer>

    public init(store: StoreOf<AppReducer>) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(store, observe: { $0 }, content: { viewStore in
            switch viewStore.state.tabSelection {
            case .direction:
                DirectionView(store: store.scope(state: \.direction, action: AppReducer.Action.direction))

            case .adventure:
                AdventureView(store: store.scope(state: \.adventure, action: AppReducer.Action.adventure))

            case .cheating:
                CheatingView(store: store.scope(state: \.cheating, action: AppReducer.Action.cheating))
            }
        })
    }
}

public struct SelectedTabView_Previews: PreviewProvider {
    public static var previews: some View {
        SelectedTabView(store: Store(initialState: AppReducer.State(), reducer: AppReducer()))
    }
}
