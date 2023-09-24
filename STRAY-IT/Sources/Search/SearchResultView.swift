import ComposableArchitecture
import SwiftUI

public struct SearchResultView: View {
    public typealias Reducer = SearchReducer
    private let store: StoreOf<Reducer>

    public init(store: StoreOf<Reducer>) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(store, observe: { $0 }, content: { viewStore in
            if let searchStatus = viewStore.state.searchStatus {
                ScrollView {
                    switch searchStatus {
                    case .searching:
                        ProgressView()
                            .padding()

                    case .noResult:
                        Text("No Results")
                            .foregroundStyle(.gray)
                            .padding()

                    case .searched:
                        SearchResultList(store: store)
                    }
                }
            }
        })
    }
}

#Preview {
    SearchResultView(store: Store(
        initialState: SearchResultView.Reducer.State(),
        reducer: { SearchResultView.Reducer() }
    ))
}
