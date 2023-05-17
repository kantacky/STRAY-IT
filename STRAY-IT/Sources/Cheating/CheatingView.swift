import ComposableArchitecture
import ExtendedMKModels
import MapKit
import Resource
import SwiftMKMap
import SwiftUI

public struct CheatingView: View {
    private let store: StoreOf<CheatingReducer>

    public init(store: StoreOf<CheatingReducer>) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(store, observe: { $0 }, content: { viewStore in
            SwiftMKMapView(
                region: viewStore.binding(
                    get: \.region,
                    send: CheatingReducer.Action.setRegion
                ),
                userTrackingMode: .constant(.followWithHeading),
                annotations: viewStore.binding(
                    get: \.annotations,
                    send: CheatingReducer.Action.setAnnotations
                ),
                pathPoints: viewStore.binding(
                    get: \.pathPoints,
                    send: CheatingReducer.Action.setPathPoints
                ),
                annotationImage: Asset.Assets.marker.image,
                strokeColor: Asset.Colors.route.swiftUIColor
            )
            .background(Asset.Colors.background.swiftUIColor)
            .ignoresSafeArea(edges: [.top, .horizontal])
            .onAppear {
                viewStore.send(.onAppear)
            }
        })
    }
}

public struct CheatingView_Previews: PreviewProvider {
    public static var previews: some View {
        CheatingView(
            store: Store(
                initialState: CheatingReducer.State(
                    region: MKCoordinateRegion(
                        center: CLLocationCoordinate2DMake(35.681042, 139.767214),
                        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                    ),
                    annotations: [
                        Annotation(coordinate: CLLocationCoordinate2DMake(35.683588, 139.750323)),
                        Annotation(coordinate: CLLocationCoordinate2DMake(35.681042, 139.767214))
                    ],
                    pathPoints: [
                        CLLocationCoordinate2DMake(35.683588, 139.750323),
                        CLLocationCoordinate2DMake(35.681042, 139.767214)
                    ]
                ),
                reducer: CheatingReducer()
            )
        )
    }
}
