import ComposableArchitecture
import Resource
import SwiftUI

struct SearchResultList: View {
    private let store: StoreOf<SearchReducer>

    public init(store: StoreOf<SearchReducer>) {
        self.store = store
    }

    var body: some View {
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
                    .foregroundColor(Asset.Colors.accent.swiftUIColor)
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

struct SearchResultList_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultList(store: Store(initialState: SearchReducer.State(), reducer: SearchReducer()))
    }
}
