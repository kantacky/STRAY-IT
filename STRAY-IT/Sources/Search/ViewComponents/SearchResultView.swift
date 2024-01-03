import ComposableArchitecture
import SwiftUI

public struct SearchResultView: View {
    public typealias Reducer = SearchReducer
    private let store: StoreOf<Reducer>
    @StateObject private var viewStore: ViewStoreOf<Reducer>

    public init(store: StoreOf<Reducer>) {
        self.store = store
        self._viewStore = .init(wrappedValue: ViewStore(store, observe: { $0 }))
    }

    public var body: some View {
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
    }
}

#Preview {
    SearchResultView(store: Store(
        initialState: SearchResultView.Reducer.State(),
        reducer: { SearchResultView.Reducer() }
    ))
}
