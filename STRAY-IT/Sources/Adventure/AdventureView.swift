import ComposableArchitecture
import MapKit
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
            Map {
                UserAnnotation()

                Annotation("Start", coordinate: viewStore.start, anchor: .bottom) {
                    Asset.Assets.marker.swiftUIImage
                }

                Annotation("Goal", coordinate: viewStore.goal, anchor: .bottom) {
                    Asset.Assets.marker.swiftUIImage
                }
            }
            .background(Asset.Colors.background.swiftUIColor)
            .ignoresSafeArea(edges: [.top, .horizontal])
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
        ),
        reducer: AdventureView.Reducer()
    ))
}
