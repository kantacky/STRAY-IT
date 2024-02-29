import ComposableArchitecture
import CoreLocation
import Resources
import SwiftUI

public struct DirectionView: View {
    private let store: StoreOf<Direction>

    public init(store: StoreOf<Direction>) {
        self.store = store
    }

    public var body: some View {
        ZStack {
            Image.decoration
            Image.direction
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .rotationEffect(.degrees(store.directionToGoal))

            LandmarksView(landmarks: store.landmarks)

            Text("\(Int(store.distanceToGoal)) m")
                .foregroundStyle(Color.accentFont)
                .font(.title2)
                .fontWeight(.semibold)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.primaryBackground)
        .ignoresSafeArea(edges: [.top, .horizontal])
    }
}

#Preview {
    DirectionView(store: Store(
        initialState: Direction.State(
            start: .init(latitude: 35.681042, longitude: 139.767214),
            goal: .init(latitude: 35.683588, longitude: 139.750323)
        )
    ) {
        Direction()
    })
}
