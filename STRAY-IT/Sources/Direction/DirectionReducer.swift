import ComposableArchitecture
import ComposableCoreLocation
import Dependency
import ExtendedMKModels
import SharedLogic

public struct DirectionReducer: ReducerProtocol {
    @Dependency(\.userDefaults)
    private var userDefaults: UserDefaultsClient
    @Dependency(\.locationManager)
    private var locationManager: LocationManager

    public init() {}

    public struct State: Equatable {
        public var currentCoordinate: CLLocationCoordinate2D
        public var headingDirection: Double
        public var goal: Annotation?
        public var distanceToGoal: Double
        public var directionToGoal: Double
        public var landmarks: [Annotation]

        public init() {
            self.currentCoordinate = .init(latitude: 0.0, longitude: 0.0)
            self.headingDirection = 0.0
            self.distanceToGoal = 0
            self.directionToGoal = 0.0
            self.landmarks = []
        }
    }

    public enum Action: Equatable {
        case onAppear
        case setGoal
        case locationManager(LocationManager.Action)
    }

    public func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .onAppear:
            if state.goal == nil {
                return .task { .setGoal }
            }
            return .none

        case .setGoal:
            if let goal: Annotation = try? userDefaults.customType(forKey: UserDefaultsKeys.goal) {
                state.goal = goal
            }
            return .none

        case let .locationManager(.didUpdateLocations(locations)):
            guard let location = locations.first else {
                return .none
            }
            state.currentCoordinate = location.coordinate
            if let goal = state.goal {
                state.distanceToGoal = LocationLogic.getDistance(originLC: state.currentCoordinate, targetLC: goal.coordinate)
                state.directionToGoal = LocationLogic.getDirectionDelta(location.coordinate, goal.coordinate, heading: state.headingDirection)
            } else {
                state.directionToGoal = 0
            }
            return .none

        case let .locationManager(.didUpdateHeading(heading)):
            state.headingDirection = heading.magneticHeading
            if let goal = state.goal {
                state.distanceToGoal = LocationLogic.getDirectionDelta(state.currentCoordinate, goal.coordinate, heading: state.headingDirection)
            } else {
                state.directionToGoal = 0.0
            }
            return .none

        default:
            return .none
        }
    }
}
