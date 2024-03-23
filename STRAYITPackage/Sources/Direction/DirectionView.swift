import ComposableArchitecture
import CoreLocation
import STRAYITResource
import SwiftUI

public struct DirectionView: View {
    private let store: StoreOf<Direction>

    public init(store: StoreOf<Direction>) {
        self.store = store
    }

    public var body: some View {
        Image.decoration
            .overlay {
                LandmarksView(landmarks: store.landmarks)
            }
            .overlay {
                Image.direction
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .rotationEffect(.degrees(store.directionToGoal))
            }
            .overlay {
                Text("\(Int(store.distanceToGoal)) m")
                    .frame(maxWidth: 100)
                    .lineLimit(1)
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
