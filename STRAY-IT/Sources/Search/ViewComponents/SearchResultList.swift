import Assets
import ComposableArchitecture
import SwiftUI

public struct SearchResultList: View {
    public typealias Reducer = SearchReducer
    private let store: StoreOf<Reducer>
    @StateObject private var viewStore: ViewStoreOf<Reducer>

    public init(store: StoreOf<Reducer>) {
        self.store = store
        self._viewStore = .init(wrappedValue: ViewStore(store, observe: { $0 }))
    }

    public var body: some View {
        ForEach(viewStore.state.querySearchResults, id: \.self) { result in
            Button {
                viewStore.send(.onSelectResult(result), animation: .default)
            } label: {
                HStack {
                    VStack {
                        HStack {
                            Text(result.name ?? "No Name")
                            Spacer()
                        }
                        .padding(.vertical, 2.0)
                    }
                    .multilineTextAlignment(.leading)

                    Spacer()
                }
                .foregroundStyle(ColorAssets.accent)
            }
            .padding(.top, 8.0)
            .padding(.bottom, 2.0)
            .padding(.horizontal, 32.0)
            Divider()
                .padding(.horizontal)
        }
    }
}

#if DEBUG
#Preview {
    SearchResultList(store: Store(
        initialState: SearchResultList.Reducer.State()
    ) {
        SearchResultList.Reducer()
    })
}
#endif
