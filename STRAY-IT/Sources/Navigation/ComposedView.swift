import Adventure
import Cheating
import ComposableArchitecture
import CoreLocation
import Direction
import SwiftUI

public struct ComposedView: View {
    public typealias Reducer = ComposedReducer
    private let store: StoreOf<Reducer>
    @StateObject private var viewStore: ViewStoreOf<Reducer>

    public init(store: StoreOf<Reducer>) {
        self.store = store
        self._viewStore = .init(wrappedValue: ViewStore(store, observe: { $0 }))
    }

    public var body: some View {
        ZStack {
            VStack(spacing: 0) {
                switch viewStore.state.tabSelection {
                case .direction:
                    DirectionView(store: store.scope(
                        state: \.direction,
                        action: Reducer.Action.direction
                    ))

                    //                    case .adventure:
                    //                        AdventureView(store: store.scope(
                    //                            state: \.adventure,
                    //                            action: Reducer.Action.adventure
                    //                        ))

                case .cheating:
                    CheatingView(store: store.scope(
                        state: \.cheating,
                        action: Reducer.Action.cheating
                    ))
                }

                CustomTabBar(
                    selection: viewStore.binding(
                        get: \.tabSelection,
                        send: Reducer.Action.setTabSelection
                    )
                )
            }

            VStack {
                HStack {
                    SearchButton()
                        .onTapGesture {
                            viewStore.send(.onSearchButtonTapped)
                        }
                        .padding()
                    Spacer()
                }
                Spacer()
            }
        }
        .onAppear { viewStore.send(.onAppear) }
        .onDisappear { viewStore.send(.onDisappear) }
    }
}

#if DEBUG
#Preview {
    ComposedView(store: Store(
        initialState: ComposedView.Reducer.State(
            start: CLLocationCoordinate2DMake(35.683588, 139.750323),
            goal: CLLocationCoordinate2DMake(35.681042, 139.767214)
        ),
        reducer: { ComposedView.Reducer() }
    ))
}
#endif
