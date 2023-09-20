import ComposableArchitecture
import CoreLocation
import LocationManager
import SharedModel

public struct DirectionReducer: Reducer {
    @Dependency(\.locationManager)
    private var locationManager: LocationManager

    public init() {}

    public struct State: Equatable {
        public var coordinate: CLLocationCoordinate2D
        public var degrees: CLLocationDirection
        public var goal: CLLocationCoordinate2D
        public var distanceToGoal: Double
        public var directionToGoal: Double
        public var landmarks: [Landmark]

        public init(
            coordinate: CLLocationCoordinate2D = .init(latitude: 0, longitude: 0),
            degrees: CLLocationDirection = 0,
            goal: CLLocationCoordinate2D = .init(latitude: 0, longitude: 0),
            landmarks: [Landmark] = []
        ) {
            self.coordinate = coordinate
            self.degrees = degrees
            self.goal = goal
            self.distanceToGoal = 0
            self.directionToGoal = 0
            self.landmarks = landmarks
        }
    }

    public enum Action: Equatable {
        case onAppear
        case onChangeCoordinate(CLLocationCoordinate2D)
        case onChangeDegrees(CLLocationDirection)
        case calculate
    }

    public func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .onAppear:
            if let coordinate = locationManager.getCoordinate() {
                state.coordinate = coordinate
            }
            if let degrees = locationManager.getHeading() {
                state.degrees = degrees
            }
            return .run { send in
                await send(.calculate)
            }

        case let .onChangeCoordinate(coordinate):
            state.coordinate = coordinate
            return .run { send in
                await send(.calculate)
            }

        case let .onChangeDegrees(degrees):
            state.degrees = degrees
            return .run { send in
                await send(.calculate)
            }

        case .calculate:
            state.distanceToGoal = LocationLogic.getDistance(originLC: state.coordinate, targetLC: state.goal)
            state.directionToGoal = LocationLogic.getDirectionDelta(state.coordinate, state.goal, heading: state.degrees)
            return .none
        }
    }
}
