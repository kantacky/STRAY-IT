import ComposableArchitecture
import Resource
import SwiftUI

public struct SearchButton: View {
    public typealias Reducer = CoreReducer

    private let store: StoreOf<Reducer>

    public init(store: StoreOf<Reducer>) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(self.store, observe: { $0 }, content: { viewStore in
            Button(action: {
                viewStore.send(.onSearchButtonTapped)
            }, label: {
                Asset.Assets.searchSmall.swiftUIImage
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32)
            })
            .padding()
            .background(Asset.Colors.accent.swiftUIColor)
            .clipShape(Circle())
        })
    }
}

#Preview {
    SearchButton(store: Store(
        initialState: SearchButton.Reducer.State(),
        reducer: SearchButton.Reducer()
    ))
}
