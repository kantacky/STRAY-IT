import Adventure
import Cheating
import ComposableArchitecture
import ComposableCoreLocation
import Dependency
import Direction
import ExtendedMKModels
import Foundation
import Search
import SharedModel

public struct AppReducer: ReducerProtocol {
    @Dependency(\.userDefaults)
    private var userDefaults: UserDefaultsClient
    @Dependency(\.locationManager)
    private var locationManager: LocationManager

    private struct LocationManagerId: Hashable {}

    public struct State: Equatable {
        public var alert: AlertState<Action>?
        public var tabSelection: TabSelection
        public var currentCoordinate: CLLocationCoordinate2D?

        public var search: SearchReducer.State
        public var direction: DirectionReducer.State
        public var adventure: AdventureReducer.State
        public var cheating: CheatingReducer.State

        public init() {
            self.tabSelection = .direction

            self.search = .init()
            self.direction = .init()
            self.adventure = .init()
            self.cheating = .init()
        }
    }

    public enum Action: Equatable {
        case onAppear
        case onDisappear

        case alertDismissed

        case onSearchButtonTapped
        case resetStartAndGoal
        case resetStartAndGoalResponse(TaskResult<Bool>)
        case setTabSelection(TabSelection)
        case setCurrentLocationResponse(TaskResult<Bool>)

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
            return .merge(
                .cancel(id: LocationManagerId()),
                .task { .resetStartAndGoal }
            )

        case .alertDismissed:
            state.alert = nil
            return .none

        case .onSearchButtonTapped:
            return .task { .resetStartAndGoal }

        case .resetStartAndGoal:
            return .task {
                .resetStartAndGoalResponse(
                    await TaskResult {
                        try await userDefaults.set(nil, forKey: UserDefaultsKeys.start)
                        try await userDefaults.set(nil, forKey: UserDefaultsKeys.goal)
                        return true
                    }
                )
            }

        case let .setTabSelection(newTab):
            state.tabSelection = newTab
            return .none

        case .setCurrentLocationResponse(.success):
            return .none

        case let .setCurrentLocationResponse(.failure(error)):
            state.alert = .init(
                title: .init("Error"),
                message: .init(error.localizedDescription)
            )
            return .none

        case .locationManager(.didChangeAuthorization(.authorizedAlways)), .locationManager(.didChangeAuthorization(.authorizedWhenInUse)):
            return locationManager
                .requestLocation()
                .fireAndForget()

        case .locationManager(.didChangeAuthorization(.denied)), .locationManager(.didChangeAuthorization(.restricted)):
            state.alert = .init(
                title: .init("Enable the Location Service"),
                message: .init("For full access to this app")
            )
            return .none

        case let .locationManager(.didUpdateLocations(locations)):
            guard let location: Location = locations.first else {
                return .none
            }
            return .task {
                .setCurrentLocationResponse(
                    await TaskResult {
                        try await userDefaults.set(location.coordinate, forKey: UserDefaultsKeys.currentLocation)
                        return true
                    }
                )
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
