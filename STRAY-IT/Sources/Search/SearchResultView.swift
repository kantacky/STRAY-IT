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
