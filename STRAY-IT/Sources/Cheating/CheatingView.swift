import ComposableArchitecture
import _MapKit_SwiftUI
import Resource
import SwiftUI

public struct CheatingView: View {
    public typealias Reducer = CheatingReducer

    private let store: StoreOf<Reducer>

    public init(store: StoreOf<Reducer>) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(self.store, observe: { $0 }, content: { viewStore in
            Map(position: viewStore.binding(get: \.postion, send: Reducer.Action.onChangePosition)) {
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
            .mapControlVisibility(.visible)
            .background(Asset.Colors.background.swiftUIColor)
            .onAppear {
                viewStore.send(.onAppear)
            }
        })
    }
}

#Preview {
    CheatingView(store: Store(
        initialState: CheatingView.Reducer.State(
            start: CLLocationCoordinate2DMake(35.683588, 139.750323),
            goal: CLLocationCoordinate2DMake(35.681042, 139.767214)
        ),
        reducer: CheatingView.Reducer()
    ))
}

#Preview {
    CheatingView(store: Store(
        initialState: CheatingView.Reducer.State(
            start: CLLocationCoordinate2DMake(35.683588, 139.750323),
            goal: CLLocationCoordinate2DMake(35.681042, 139.767214),
            points: [
                CLLocationCoordinate2DMake(35.679579, 139.757615),
                CLLocationCoordinate2DMake(35.678550, 139.760955),
                CLLocationCoordinate2DMake(35.682187, 139.762234),
                CLLocationCoordinate2DMake(35.681658, 139.764547)
            ]
        ),
        reducer: CheatingView.Reducer()
    ))
}
