import ComposableArchitecture
import Resource
import SwiftUI

public struct SearchResultView: View {
    public typealias Reducer = SearchReducer

    private let store: StoreOf<Reducer>

    public init(store: StoreOf<Reducer>) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(store, observe: { $0 }, content: { viewStore in
            ScrollView {
                if viewStore.state.isSearching {
                    ProgressView()
                        .padding()
                } else if !viewStore.state.searchQuery.isEmpty && viewStore.state.querySearchResults.isEmpty {
                    Text("No Results")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    SearchResultList(store: store)
                }
            }
        })
    }
}

#Preview {
    SearchResultView(store: Store(
        initialState: SearchResultView.Reducer.State()
    ) {
        SearchResultView.Reducer()
    })
}
