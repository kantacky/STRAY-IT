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
            start: CLLocationCoordinate2D,
            goal: CLLocationCoordinate2D
        ) {
            self.coordinate = start
            self.degrees = 0
            self.goal = goal
            self.distanceToGoal = LocationLogic.getDistance(
                originLC: start,
                targetLC: goal
            )
            self.directionToGoal = 0
            self.landmarks = []
        }
    }

    public enum Action: Equatable {
        case calculate
        case onChangeCoordinate(CLLocationCoordinate2D)
        case onChangeDegrees(CLLocationDirection)
    }

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .calculate:
                state.distanceToGoal = LocationLogic.getDistance(
                    originLC: state.coordinate,
                    targetLC: state.goal
                )
                state.directionToGoal = LocationLogic.getDirectionDelta(
                    state.coordinate,
                    state.goal,
                    heading: state.degrees
                )
                return .none
                
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
            }
        }
    }
}
