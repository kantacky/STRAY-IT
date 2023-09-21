import ComposableArchitecture
import CoreLocation
import Resource
import SwiftUI

public struct DirectionView: View {
    public typealias Reducer = DirectionReducer
    private let store: StoreOf<Reducer>

    public init(store: StoreOf<Reducer>) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(self.store, observe: { $0 }, content: { viewStore in
            ZStack {
                Asset.Assets.directionViewDecoration.swiftUIImage
                Asset.Assets.direction.swiftUIImage
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .rotationEffect(.degrees(viewStore.state.directionToGoal))

                LandmarksView(store: self.store)

                Text("\(Int(viewStore.state.distanceToGoal)) m")
                    .foregroundColor(Asset.Colors.accentFont.swiftUIColor)
                    .font(.title2)
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Asset.Colors.background.swiftUIColor)
            .ignoresSafeArea(edges: [.top, .horizontal])
        })
    }
}

#Preview {
    DirectionView(store: Store(
        initialState: DirectionView.Reducer.State(
            start: .init(latitude: 35.681042, longitude: 139.767214),
            goal: .init(latitude: 35.683588, longitude: 139.750323)
        ),
        reducer: { DirectionView.Reducer() }
    ))
}
