import ComposableArchitecture
import STRAYITResource
import SwiftUI

public struct SearchResultList: View {
    private let store: StoreOf<Search>

    public init(store: StoreOf<Search>) {
        self.store = store
    }

    public var body: some View {
        ForEach(store.querySearchResults, id: \.self) { result in
            Button {
                store.send(.onSelectResult(result), animation: .default)
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
                .foregroundStyle(Color.primaryFont)
            }
            .padding(.top, 8.0)
            .padding(.bottom, 2.0)
            .padding(.horizontal, 32.0)

            Divider()
                .padding(.horizontal)
        }
    }
}

#Preview {
    SearchResultList(store: Store(initialState: Search.State()) {
        Search()
    })
}
