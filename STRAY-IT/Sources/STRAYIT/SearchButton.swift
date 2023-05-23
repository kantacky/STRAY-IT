import ComposableArchitecture
import Resource
import SwiftUI

struct SearchButton: View {
    public typealias Reducer = AppReducer

    private let store: StoreOf<Reducer>

    public init(store: StoreOf<Reducer>) {
        self.store = store
    }

    var body: some View {
        WithViewStore(self.store, observe: { $0 }, content: { viewStore in
            Button(action: {
                viewStore.send(.onSearchButtonTapped)
            }, label: {
                Asset.Assets.search.swiftUIImage
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

struct SearchButton_Previews: PreviewProvider {
    static var previews: some View {
        SearchButton(store: Store(initialState: ComposedTabView.Reducer.State(), reducer: ComposedTabView.Reducer()))
    }
}
