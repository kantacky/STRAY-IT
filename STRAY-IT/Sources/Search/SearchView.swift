import ComposableArchitecture
import Resources
import SwiftUI

public struct SearchView: View {
    @Bindable private var store: StoreOf<Search>

    public init(store: StoreOf<Search>) {
        self.store = store
    }

    public var body: some View {
        VStack {
            SearchBox(searchQuery: $store.searchQuery.sending(\.setSearchQuery))
                .shadow(radius: 4, x: 4, y: 4)
                .padding()

            SearchResultView(store: store)

            Spacer()
        }
        .onDisappear {store.send(.onDisappear)}
        .background(Color.primaryBackground)
    }
}

#Preview {
    SearchView(store: Store(initialState: Search.State()) {
        Search()
    })
}
