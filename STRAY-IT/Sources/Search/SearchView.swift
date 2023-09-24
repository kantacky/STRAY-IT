import ComposableArchitecture
import SwiftUI

public struct SearchView: View {
    public typealias Reducer = SearchReducer

    private let store: StoreOf<Reducer>

    public init(store: StoreOf<Reducer>) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(self.store, observe: { $0 }, content: { viewStore in
            VStack {
                SearchBox(
                    searchQuery: viewStore.binding(
                        get: \.searchQuery,
                        send: Reducer.Action.setSearchQuery
                    )
                )
                .padding()

                SearchResultView(store: self.store)

                Spacer()
            }
            .onDisappear {
                viewStore.send(.onDisappear)
            }
            .background(Color(.background))
        })
    }
}

#Preview {
    SearchView(store: Store(
        initialState: SearchView.Reducer.State(),
        reducer: { SearchView.Reducer() }
    ))
}
