import ComposableArchitecture
import CoreLocation
import Resource
import SwiftUI

public struct SearchButton: View {
    public typealias Reducer = ComposedReducer
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
                    .frame(width: 24)
            })
            .padding()
            .background(Asset.Colors.accent.swiftUIColor)
            .clipShape(Circle())
        })
    }
}

#Preview {
    SearchButton(store: Store(
        initialState: SearchButton.Reducer.State(
            start: CLLocationCoordinate2DMake(35.683588, 139.750323),
            goal: CLLocationCoordinate2DMake(35.681042, 139.767214)
        ),
        reducer: { SearchButton.Reducer() }
    ))
}
