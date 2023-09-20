import Adventure
import Cheating
import Combine
import ComposableArchitecture
import CoreLocation
import Direction
import Foundation
import LocationManager
import MapKit
import Search
import SharedModel

public struct ComposedReducer: Reducer {
    // MARK: - State
    public struct State: Equatable {
        public var cancellables: Set<AnyCancellable>
        public var tabSelection: TabItem
        public var coordinate: CLLocationCoordinate2D?
        public var degrees: CLLocationDirection?
        public var start: CLLocationCoordinate2D
        public var goal: CLLocationCoordinate2D
        public var direction: DirectionReducer.State
        public var adventure: AdventureReducer.State
        public var cheating: CheatingReducer.State

        public init(
            start: CLLocationCoordinate2D,
            goal: CLLocationCoordinate2D
        ) {
            self.cancellables = .init()
            self.tabSelection = .direction
            self.start = start
            self.goal = goal
            self.direction = .init(goal: goal)
            self.adventure = .init(start: start, goal: goal)
            self.cheating = .init(start: start, goal: goal)
        }
    }

    // MARK: - Action
    public enum Action: Equatable {
        case onAppear
        case onDisappear
        case subscribeCoordinate
        case subscribeDegrees
        case onChangeCoordinate(CLLocationCoordinate2D)
        case onChangeDegrees(CLLocationDirection)
        case onSearchButtonTapped
        case setTabSelection(TabItem)
        case direction(DirectionReducer.Action)
        case adventure(AdventureReducer.Action)
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

        Scope(state: \.adventure, action: /Action.adventure) {
            AdventureReducer()
        }

        Scope(state: \.cheating, action: /Action.cheating) {
            CheatingReducer()
        }

        Reduce { state, action in
            switch action {
            case .onAppear:
                locationManager.startUpdatingLocation()
                return .run { send in
                    async let subscribeCoordinate: Void = await send(.subscribeCoordinate)
                    async let subscribeDegrees: Void = await send(.subscribeDegrees)
                    _ = await (subscribeCoordinate, subscribeDegrees)
                }

            case .onDisappear:
                Task.cancel(id: CancelID.coordinateSubscription)
                Task.cancel(id: CancelID.degreesSubscription)
                locationManager.stopUpdatingLocation()
                return .none

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
                    await send(.adventure(.onChangeCoordinate(coordinate)))
                    await send(.cheating(.onChangeCoordinate(coordinate)))
                }

            case let .onChangeDegrees(degrees):
                return .run { send in
                    await send(.direction(.onChangeDegrees(degrees)))
                    await send(.adventure(.onChangeDegrees(degrees)))
                    await send(.cheating(.onChangeDegrees(degrees)))
                }

            case .onSearchButtonTapped:
                return .none

            case let .setTabSelection(newTab):
                state.tabSelection = newTab
                return .none

            default:
                return .none
            }
        }
    }
}
