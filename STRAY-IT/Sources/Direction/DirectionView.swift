import ComposableArchitecture
import Resource
import SwiftUI

public struct DirectionView: View {
    private let store: StoreOf<DirectionReducer>

    public init(store: StoreOf<DirectionReducer>) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(store, observe: { $0 }, content: { viewStore in
            ZStack {
                Asset.Assets.directionViewDecoration.swiftUIImage
                Asset.Assets.direction.swiftUIImage
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .rotationEffect(.degrees(viewStore.state.headingDirection))
                Landmarks()
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

public struct DirectionView_Previews: PreviewProvider {
    public static var previews: some View {
        DirectionView(store: Store(initialState: DirectionReducer.State(), reducer: DirectionReducer()))
    }
}
