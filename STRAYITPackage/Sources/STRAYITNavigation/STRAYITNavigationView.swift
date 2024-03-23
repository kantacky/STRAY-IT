import Cheating
import ComposableArchitecture
import Direction
import STRAYITComponent
import SwiftUI

public struct STRAYITNavigationView: View {
    @Bindable private var store: StoreOf<STRAYITNavigation>

    public init(store: StoreOf<STRAYITNavigation>) {
        self.store = store
    }

    public var body: some View {
        ZStack {
            VStack(spacing: 0) {
                switch store.selectedMode {
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

                CustomTabBar(mode: $store.selectedMode)
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
    STRAYITNavigationView(store: Store(
        initialState: STRAYITNavigation.State(
            start: .init(latitude: 35.683588, longitude: 139.750323),
            goal: .init(latitude: 35.681042, longitude: 139.767214)
        )
    ) {
        STRAYITNavigation()
    })
}
