import ComposableArchitecture
import Resource
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
                        send: SearchReducer.Action.setSearchQuery
                    )
                )
                .padding()

                SearchResultView(store: self.store)

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
        SearchView(store: Store(initialState: SearchView.Reducer.State(), reducer: SearchView.Reducer()))
    }
}
