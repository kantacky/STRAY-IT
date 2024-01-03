import _MapKit_SwiftUI
import ComposableArchitecture
import Resources
import SwiftUI

public struct AdventureView: View {
    public typealias Reducer = AdventureReducer
    private let store: StoreOf<Reducer>
    @StateObject private var viewStore: ViewStoreOf<Reducer>

    public init(store: StoreOf<Reducer>) {
        self.store = store
        self._viewStore = .init(wrappedValue: ViewStore(store, observe: { $0 }))
    }

    public var body: some View {
        Map(position: viewStore.binding(
            get: \.position,
            send: Reducer.Action.onChangePosition
        )) {
            UserAnnotation()
                .mapOverlayLevel(level: .aboveLabels)

            Annotation("Start", coordinate: viewStore.start, anchor: .bottom) {
                Image.marker
            }
            .mapOverlayLevel(level: .aboveRoads)

            Annotation("Goal", coordinate: viewStore.goal, anchor: .bottom) {
                Image.marker
            }
            .mapOverlayLevel(level: .aboveRoads)

            MapPolyline(coordinates: viewStore.points)
                .stroke(
                    Color.route,
                    style: .init(
                        lineWidth: 8,
                        lineCap: .round,
                        lineJoin: .round
                    )
                )
                .mapOverlayLevel(level: .aboveRoads)
        }
        .mapControlVisibility(.hidden)
        .background(Color.background)
    }
}

#Preview {
    AdventureView(store: Store(
        initialState: AdventureView.Reducer.State(
            start: .init(latitude: 35.681042, longitude: 139.767214),
            goal: .init(latitude: 35.683588, longitude: 139.750323)
        )
    ) {
        AdventureView.Reducer()
    })
}
