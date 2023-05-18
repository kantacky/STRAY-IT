import ComposableArchitecture
import Resource
import SwiftUI

public struct SearchView: View {
    private let store: StoreOf<SearchReducer>

    public init(store: StoreOf<SearchReducer>) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(store, observe: { $0 }, content: { viewStore in
            VStack {
                SearchBox(
                    searchQuery: viewStore.binding(
                        get: \.searchQuery,
                        send: SearchReducer.Action.setSearchQuery
                    )
                )
                .padding()
                SearchResultView(store: store)
                Spacer()
            }
            .onAppear {
                viewStore.send(.onAppear)
            }
            .onDisappear {
                viewStore.send(.onDisappear)
            }
            .background(Asset.Colors.background.swiftUIColor)
        })
    }
}

public struct SearchView_Previews: PreviewProvider {
    public static var previews: some View {
        SearchView(store: Store(initialState: SearchReducer.State(), reducer: SearchReducer()))
    }
}
