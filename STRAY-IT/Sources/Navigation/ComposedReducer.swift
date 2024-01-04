import Adventure
import Cheating
import Combine
import ComposableArchitecture
import CoreLocation
import Direction
import Foundation
import LocationManager
import MapKit
import Models

@Reducer
public struct ComposedReducer {
    // MARK: - State
    public struct State: Equatable {
        var tabSelection: TabItem
        var coordinate: CLLocationCoordinate2D?
        var degrees: CLLocationDirection?
        var start: CLLocationCoordinate2D
        var goal: CLLocationCoordinate2D
        var direction: DirectionReducer.State
        var cheating: CheatingReducer.State

        public init(
            start: CLLocationCoordinate2D,
            goal: CLLocationCoordinate2D
        ) {
            self.tabSelection = .direction
            self.start = start
            self.goal = goal
            self.direction = .init(start: start, goal: goal)
            self.cheating = .init(start: start, goal: goal)
        }
    }

    // MARK: - Action
    public enum Action: Equatable {
        case onAppear
        case subscribeCoordinate
        case subscribeDegrees
        case onChangeCoordinate(CLLocationCoordinate2D)
        case onChangeDegrees(CLLocationDirection)
        case onSearchButtonTapped
        case setTabSelection(TabItem)
        case direction(DirectionReducer.Action)
        case cheating(CheatingReducer.Action)
    }

    // MARK: - Dependency
    @Dependency(\.locationManager)
    private var locationManager: LocationManager

    public enum CancelID {
        case coordinateSubscription, degreesSubscription
    }

    public init() {}

    // MARK: - Reducer
    public var body: some Reducer<State, Action> {
        Scope(state: \.direction, action: /Action.direction) {
            DirectionReducer()
        }

        Scope(state: \.cheating, action: /Action.cheating) {
            CheatingReducer()
        }

        Reduce { state, action in
            switch action {
            case .onAppear:
                self.locationManager.startUpdatingLocation()
                self.locationManager.enableBackgroundLocationUpdates()
                return .run { send in
                    async let subscribeCoordinate: Void = await send(.subscribeCoordinate)
                    async let subscribeDegrees: Void = await send(.subscribeDegrees)
                    _ = await (subscribeCoordinate, subscribeDegrees)
                }

            case .subscribeCoordinate:
                return .run { send in
                    for await value in locationManager.coordinate {
                        Task.detached { @MainActor in
                            send(.onChangeCoordinate(value))
                        }
                    }
                }
                .cancellable(id: CancelID.coordinateSubscription)

            case .subscribeDegrees:
                return .run { send in
                    for await value in locationManager.degrees {
                        Task.detached { @MainActor in
                            send(.onChangeDegrees(value))
                        }
                    }
                }
                .cancellable(id: CancelID.degreesSubscription)

            case let .onChangeCoordinate(coordinate):
                return .run { send in
                    await send(.direction(.onChangeCoordinate(coordinate)))
                    await send(.cheating(.onChangeCoordinate(coordinate)))
                }

            case let .onChangeDegrees(degrees):
                return .run { send in
                    await send(.direction(.onChangeDegrees(degrees)))
                    await send(.cheating(.onChangeDegrees(degrees)))
                }

            case .onSearchButtonTapped:
                Task.cancel(id: CancelID.coordinateSubscription)
                Task.cancel(id: CancelID.degreesSubscription)
                self.locationManager.disableBackgroundLocationUpdates()
                self.locationManager.stopUpdatingLocation()
                return .none

            case let .setTabSelection(newTab):
                state.tabSelection = newTab
                return .none

            case .direction:
                return .none

            case .cheating:
                return .none
            }
        }
    }
}
