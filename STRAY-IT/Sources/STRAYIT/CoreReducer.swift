import Adventure
import Cheating
import Combine
import ComposableArchitecture
import CoreLocation
import Direction
import Foundation
import MapKit
import Search
import SharedModel

public struct CoreReducer: Reducer {
    @Dependency(\.locationManager)
    private var locationManager: LocationManager

    public enum CancelID {
        case coordinateSubscription, degreesSubscription
    }

    public init() {}

    public struct State: Equatable {
        public var alert: Alert?
        public var cancellables: Set<AnyCancellable>
        public var tabSelection: TabItem
        public var coordinate: CLLocationCoordinate2D?
        public var degrees: CLLocationDirection?
        public var search: SearchReducer.State
        public var direction: DirectionReducer.State
        public var adventure: AdventureReducer.State
        public var cheating: CheatingReducer.State

        public init(
            coordinate: CLLocationCoordinate2D? = nil,
            degrees: CLLocationDirection? = nil,
            search: SearchReducer.State = .init(),
            direction: DirectionReducer.State = .init(),
            adventure: AdventureReducer.State = .init(),
            cheating: CheatingReducer.State = .init()
        ) {
            self.cancellables = .init()
            self.tabSelection = .direction
            self.coordinate = coordinate
            self.degrees = degrees
            self.search = search
            self.direction = direction
            self.adventure = adventure
            self.cheating = cheating
        }
    }

    public enum Action: Equatable {
        case onAppear
        case onDisappear
        case setAlert(String, String)
        case alertDismissed
        case subscribeCoordinate
        case subscribeDegrees
        case onChangeCoordinate(CLLocationCoordinate2D)
        case onChangeDegrees(CLLocationDirection)
        case onSearchButtonTapped
        case setTabSelection(TabItem)
        case onResetStartAndGoal
        case search(SearchReducer.Action)
        case direction(DirectionReducer.Action)
        case adventure(AdventureReducer.Action)
        case cheating(CheatingReducer.Action)
    }

    public func core(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .onAppear:
            locationManager.startUpdatingLocation()
            return .run { send in
                async let subscribeCoordinate: Void = await send(.subscribeCoordinate)
                async let subscribeDegrees: Void = await send(.subscribeDegrees)
                _ = await (subscribeCoordinate, subscribeDegrees)
            }

        case .onDisappear:
            return .run { send in
                await send(.onResetStartAndGoal)
            }

        case let .setAlert(title, message):
            state.alert = .init(title: title, message: message)
            return .none

        case .alertDismissed:
            state.alert = nil
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
            return .run { send in
                await send(.onResetStartAndGoal)
            }

        case let .setTabSelection(newTab):
            state.tabSelection = newTab
            return .none

        case .onResetStartAndGoal:
            UserDefaults.standard.removeObject(forKey: "start")
            UserDefaults.standard.removeObject(forKey: "goal")
            return .none

        default:
            return .none
        }
    }

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            self.core(into: &state, action: action)
        }

        Scope(state: \.search, action: /Action.search) {
            SearchReducer()
        }
        Scope(state: \.direction, action: /Action.direction) {
            DirectionReducer()
        }
        Scope(state: \.adventure, action: /Action.adventure) {
            AdventureReducer()
        }
        Scope(state: \.cheating, action: /Action.cheating) {
            CheatingReducer()
        }
    }
}
