import ComposableArchitecture
import CoreLocation
import Resources
import SwiftUI

public struct DirectionView: View {
    public typealias Reducer = DirectionReducer
    private let store: StoreOf<Reducer>
    @StateObject private var viewStore: ViewStoreOf<Reducer>

    public init(store: StoreOf<Reducer>) {
        self.store = store
        self._viewStore = .init(wrappedValue: ViewStore(store, observe: { $0 }))
    }

    public var body: some View {
        ZStack {
            Image.decoration
            Image.direction
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .rotationEffect(.degrees(viewStore.state.directionToGoal))

            LandmarksView(landmarks: self.viewStore.landmarks)

            Text("\(Int(viewStore.state.distanceToGoal)) m")
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
        initialState: DirectionView.Reducer.State(
            start: .init(latitude: 35.681042, longitude: 139.767214),
            goal: .init(latitude: 35.683588, longitude: 139.750323)
        )
    ) {
        DirectionView.Reducer()
    })
}
