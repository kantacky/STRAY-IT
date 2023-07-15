import Adventure
import Cheating
import ComposableArchitecture
import ComposableCoreLocation
import Dependency
import Direction
import Foundation
import Search
import SharedModel

public struct CoreReducer: ReducerProtocol {
    @Dependency(\.locationManager)
    private var locationManager: LocationManager

    private struct LocationManagerId: Hashable {}

    public struct State: Equatable {
        public var alert: AlertState<Action>?

        public var tabSelection: TabSelection

        public var coordinate: CLLocationCoordinate2D?

        public var search: SearchReducer.State
        public var direction: DirectionReducer.State
        public var adventure: AdventureReducer.State
        public var cheating: CheatingReducer.State

        public init(
            coordinate: CLLocationCoordinate2D? = nil,
            search: SearchReducer.State = .init(),
            direction: DirectionReducer.State = .init(),
            adventure: AdventureReducer.State = .init(),
            cheating: CheatingReducer.State = .init()
        ) {
            self.tabSelection = .direction

            self.coordinate = coordinate

            self.search = search
            self.direction = direction
            self.adventure = adventure
            self.cheating = cheating
        }
    }

    public enum Action: Equatable {
        case onAppear
        case onDisappear

        case alertDismissed

        case onSearchButtonTapped
        case setTabSelection(TabSelection)
        case setStartAndGoal

        case locationManager(LocationManager.Action)

        case search(SearchReducer.Action)
        case direction(DirectionReducer.Action)
        case adventure(AdventureReducer.Action)
        case cheating(CheatingReducer.Action)
    }

    public func core(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .onAppear:
            return .merge(
                locationManager.delegate()
                    .map(Action.locationManager)
                    .cancellable(id: LocationManagerId()),
                locationManager
                    .requestWhenInUseAuthorization()
                    .fireAndForget()
            )

        case .onDisappear:
            return .cancel(id: LocationManagerId())

        case .alertDismissed:
            state.alert = nil
            return .none

        case .onSearchButtonTapped:
            state.search.goal = nil
            return .none

        case let .setTabSelection(newTab):
            state.tabSelection = newTab
            return .none

        case .setStartAndGoal:
            if let start = state.coordinate,
               let goal = state.search.goal {
                state.direction.goal = goal

                state.adventure.start = start
                state.adventure.goal = goal

                state.cheating.start = start
                state.cheating.goal = goal
                state.cheating.points = []
            }
            return .none

        case .locationManager(.didChangeAuthorization(.authorizedAlways)),
             .locationManager(.didChangeAuthorization(.authorizedWhenInUse)):
            return locationManager
                .requestLocation()
                .fireAndForget()

        case .locationManager(.didChangeAuthorization(.denied)),
             .locationManager(.didChangeAuthorization(.restricted)):
            state.alert = .init(
                title: .init("Enable the Location Service"),
                message: .init("For full access to this app")
            )
            return .none

        case let .locationManager(.didUpdateLocations(locations)):
            guard let location: Location = locations.first else {
                return .none
            }
            print(location.coordinate)
            state.coordinate = location.coordinate

            state.cheating.points.append(location.coordinate)

            return .task {
                .direction(.onUpdateLocation(location.coordinate))
            }

        case let .locationManager(.didUpdateHeading(heading)):
            print(heading.magneticHeading)
            return .task {
                .direction(.onUpdateHeading(heading.magneticHeading))
            }

        default:
            return .none
        }
    }

    public var body: some ReducerProtocol<State, Action> {
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
