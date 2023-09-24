import ComposableArchitecture
import SwiftUI

public struct SearchResultList: View {
    public typealias Reducer = SearchReducer

    private let store: StoreOf<Reducer>

    public init(store: StoreOf<Reducer>) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(store, observe: { $0 }, content: { viewStore in
            ForEach(viewStore.state.querySearchResults, id: \.self) { result in
                Button(action: { viewStore.send(.onSelectResult(result)) }, label: {
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
                    .foregroundStyle(Color(.accent))
                })
                .padding(.top, 8.0)
                .padding(.bottom, 2.0)
                .padding(.horizontal, 32.0)
                Divider()
                    .padding(.horizontal)
            }
        })
    }
}

#Preview {
    SearchResultList(store: Store(
        initialState: SearchResultList.Reducer.State()
    ) {
        SearchResultList.Reducer()
    })
}
