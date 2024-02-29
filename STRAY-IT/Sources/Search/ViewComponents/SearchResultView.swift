import ComposableArchitecture
import SwiftUI

public struct SearchResultView: View {
    private let store: StoreOf<Search>

    public init(store: StoreOf<Search>) {
        self.store = store
    }

    public var body: some View {
        if let searchStatus = store.searchStatus {
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
    SearchResultView(store: Store(initialState: Search.State()) {
        Search()
    })
}
