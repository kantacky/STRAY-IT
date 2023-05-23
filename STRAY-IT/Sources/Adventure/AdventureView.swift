import ComposableArchitecture
import ExtendedMKModels
import MapKit
import Resource
import SwiftMKMap
import SwiftUI

public struct AdventureView: View {
    public typealias Reducer = AdventureReducer

    private let store: StoreOf<Reducer>

    public init(store: StoreOf<Reducer>) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(self.store, observe: { $0 }, content: { viewStore in
            SwiftMKMapView(
                region: viewStore.binding(
                    get: \.region,
                    send: AdventureReducer.Action.setRegion
                ),
                userTrackingMode: .constant(.followWithHeading),
                annotations: viewStore.binding(
                    get: \.annotations,
                    send: AdventureReducer.Action.setAnnotations
                ),
                pathPoints: .constant([]),
                annotationImage: Asset.Assets.marker.image
            )
            .background(Asset.Colors.background.swiftUIColor)
            .ignoresSafeArea(edges: [.top, .horizontal])
            .onAppear {
                viewStore.send(.onAppear)
            }
        })
    }
}

public struct AdventureView_Previews: PreviewProvider {
    public static var previews: some View {
        AdventureView(
            store: Store(
                initialState: AdventureView.Reducer.State(
                    region: MKCoordinateRegion(
                        center: CLLocationCoordinate2DMake(35.681042, 139.767214),
                        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                    ),
                    annotations: [
                        Annotation(coordinate: CLLocationCoordinate2DMake(35.683588, 139.750323)),
                        Annotation(coordinate: CLLocationCoordinate2DMake(35.681042, 139.767214))
                    ]
                ),
                reducer: AdventureView.Reducer()
            )
        )
    }
}
