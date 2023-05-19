import ComposableArchitecture
import SwiftUI

public struct ComposedTabView: View {
    private let store: StoreOf<AppReducer>

    public init(store: StoreOf<AppReducer>) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(store, observe: { $0 }, content: { viewStore in
            VStack(spacing: 0) {
                SelectedTabView(store: store)

                CustomTabBar(
                    selection: viewStore.binding(
                        get: \.tabSelection,
                        send: AppReducer.Action.setTabSelection
                    )
                )
            }
        })
    }
}

public struct ComposedTabView_Previews: PreviewProvider {
    public static var previews: some View {
        ComposedTabView(store: Store(initialState: AppReducer.State(), reducer: AppReducer()))
    }
}
