import Adventure
import Cheating
import ComposableArchitecture
import CoreLocation
import Direction
import SwiftUI

public struct ComposedView: View {
    @Bindable private var store: StoreOf<ComposedReducer>

    public init(store: StoreOf<ComposedReducer>) {
        self.store = store
    }

    public var body: some View {
        ZStack {
            VStack(spacing: 0) {
                switch store.tabSelection {
                case .direction:
                    DirectionView(store: store.scope(
                        state: \.direction,
                        action: \.direction
                    ))

                case .cheating:
                    CheatingView(store: store.scope(
                        state: \.cheating,
                        action: \.cheating
                    ))
                }

                CustomTabBar(selection: $store.tabSelection)
            }

            VStack {
                HStack {
                    SearchButton {
                        store.send(.onSearchButtonTapped)
                    }
                    .padding()

                    Spacer()
                }

                Spacer()
            }
        }
        .onAppear { store.send(.onAppear) }
    }
}

#Preview {
    ComposedView(store: Store(
        initialState: ComposedReducer.State(
            start: CLLocationCoordinate2DMake(35.683588, 139.750323),
            goal: CLLocationCoordinate2DMake(35.681042, 139.767214)
        )
    ) {
        ComposedReducer()
    })
}
