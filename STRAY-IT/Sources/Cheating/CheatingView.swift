import _MapKit_SwiftUI
import ComposableArchitecture
import Resources
import SwiftUI

public struct CheatingView: View {
    @Bindable private var store: StoreOf<Cheating>

    public init(store: StoreOf<Cheating>) {
        self.store = store
    }

    public var body: some View {
        Map(position: $store.position) {
            UserAnnotation()

            Annotation(
                "Start",
                coordinate: store.start,
                anchor: .bottom
            ) {
                Image.marker
                    .resizable()
                    .scaledToFit()
                    .frame(width: 48, height: 48)
            }

            Annotation(
                "Goal",
                coordinate: store.goal,
                anchor: .bottom
            ) {
                Image.marker
                    .resizable()
                    .scaledToFit()
                    .frame(width: 48, height: 48)
            }

            MapPolyline(coordinates: store.points)
                .stroke(
                    Color.primaryFont,
                    style: .init(
                        lineWidth: 8,
                        lineCap: .round,
                        lineJoin: .round
                    )
                )
        }
        .mapControlVisibility(.visible)
        .background(Color.primaryBackground)
    }
}

#Preview {
    CheatingView(store: Store(
        initialState: Cheating.State(
            start: .init(latitude: 35.681042, longitude: 139.767214),
            goal: .init(latitude: 35.683588, longitude: 139.750323)
        )
    ) {
        Cheating()
    })
}
