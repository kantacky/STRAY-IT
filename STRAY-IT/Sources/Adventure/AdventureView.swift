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
            .onAppear {
                viewStore.send(.onAppear)
            }
        })
    }
}

#Preview {
    AdventureView(store: Store(
        initialState: AdventureView.Reducer.State(
            start: CLLocationCoordinate2DMake(35.683588, 139.750323),
            goal: CLLocationCoordinate2DMake(35.681042, 139.767214)
        )
    ) {
        AdventureView.Reducer()
    })
}
