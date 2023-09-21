import _MapKit_SwiftUI
import ComposableArchitecture
import Resource
import SwiftUI

public struct AdventureView: View {
    public typealias Reducer = AdventureReducer
    private let store: StoreOf<Reducer>

    public init(store: StoreOf<Reducer>) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(self.store, observe: { $0 }, content: { viewStore in
            Map(position: viewStore.binding(
                get: \.position,
                send: Reducer.Action.onChangePosition
            )) {
                UserAnnotation()
                    .mapOverlayLevel(level: .aboveLabels)

                Annotation("Start", coordinate: viewStore.start, anchor: .bottom) {
                    Asset.Assets.marker.swiftUIImage
                }
                .mapOverlayLevel(level: .aboveRoads)

                Annotation("Goal", coordinate: viewStore.goal, anchor: .bottom) {
                    Asset.Assets.marker.swiftUIImage
                }
                .mapOverlayLevel(level: .aboveRoads)

                MapPolyline(coordinates: viewStore.points)
                    .stroke(Asset.Colors.route.swiftUIColor, lineWidth: 8)
                    .mapOverlayLevel(level: .aboveRoads)
            }
            .mapControlVisibility(.hidden)
            .background(Asset.Colors.background.swiftUIColor)
        })
    }
}

#Preview {
    AdventureView(store: Store(
        initialState: AdventureView.Reducer.State(
            start: .init(latitude: 35.681042, longitude: 139.767214),
            goal: .init(latitude: 35.683588, longitude: 139.750323)
        ),
        reducer: { AdventureView.Reducer() }
    ))
}
