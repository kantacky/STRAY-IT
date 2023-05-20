import ComposableArchitecture
import Resource
import SwiftUI

public struct SearchResultView: View {
    private let store: StoreOf<SearchReducer>

    public init(store: StoreOf<SearchReducer>) {
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

public struct SearchResultView_Previews: PreviewProvider {
    public static var previews: some View {
        SearchResultView(store: Store(initialState: SearchReducer.State(), reducer: SearchReducer()))
    }
}
