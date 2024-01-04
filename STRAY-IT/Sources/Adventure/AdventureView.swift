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
        Map(position: self.viewStore.$position) {
            UserAnnotation()

            Annotation(
                "Start",
                coordinate: viewStore.start,
                anchor: .bottom
            ) {
                Image.marker
                    .resizable()
                    .scaledToFit()
                    .frame(width: 48, height: 48)
            }

            Annotation(
                "Goal",
                coordinate: viewStore.goal,
                anchor: .bottom
            ) {
                Image.marker
                    .resizable()
                    .scaledToFit()
                    .frame(width: 48, height: 48)
            }

            MapPolyline(coordinates: viewStore.points)
                .stroke(
                    Color.primaryFont,
                    style: .init(
                        lineWidth: 8,
                        lineCap: .round,
                        lineJoin: .round
                    )
                )
        }
        .mapControlVisibility(.hidden)
        .background(Color.primaryBackground)
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
