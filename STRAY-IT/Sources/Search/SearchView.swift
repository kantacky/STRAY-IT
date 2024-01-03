import ComposableArchitecture
import Resources
import SwiftUI

public struct SearchView: View {
    public typealias Reducer = SearchReducer
    private let store: StoreOf<Reducer>
    @StateObject private var viewStore: ViewStoreOf<Reducer>

    public init(store: StoreOf<Reducer>) {
        self.store = store
        self._viewStore = .init(wrappedValue: ViewStore(store, observe: { $0 }))
    }

    public var body: some View {
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
        .background(Color.background)
    }
}

#Preview {
    SearchView(store: Store(
        initialState: SearchView.Reducer.State()
    ) {
        SearchView.Reducer()
    })
}
