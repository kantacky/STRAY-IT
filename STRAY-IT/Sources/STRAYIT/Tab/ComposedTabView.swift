import ComposableArchitecture
import SwiftUI

public struct ComposedTabView: View {
    public typealias Reducer = CoreReducer

    private let store: StoreOf<Reducer>

    public init(store: StoreOf<Reducer>) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(store, observe: { $0 }, content: { viewStore in
            ZStack {
                VStack(spacing: 0) {
                    SelectedTabView(store: store)

                    CustomTabBar(
                        selection: viewStore.binding(
                            get: \.tabSelection,
                            send: CoreReducer.Action.setTabSelection
                        )
                    )
                }

                VStack {
                    HStack {
                        SearchButton(store: store)
                            .padding()
                            .padding(.top, 24)
                        Spacer()
                    }
                    Spacer()
                }
            }
        })
    }
}

#Preview {
    ComposedTabView(store: Store(
        initialState: ComposedTabView.Reducer.State()
    ) {
        ComposedTabView.Reducer()
    })
}
