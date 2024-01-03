import ComposableArchitecture
import CoreLocation
import LocationManager
import Models

@Reducer
public struct DirectionReducer {
    // MARK: - State
    public struct State: Equatable {
        var coordinate: CLLocationCoordinate2D
        var degrees: CLLocationDirection
        var goal: CLLocationCoordinate2D
        var distanceToGoal: Double
        var directionToGoal: Double
        var landmarks: [Landmark]

        public init(
            start: CLLocationCoordinate2D,
            goal: CLLocationCoordinate2D
        ) {
            self.coordinate = start
            self.degrees = 0
            self.goal = goal
            self.distanceToGoal = start.distance(from: goal)
            self.directionToGoal = 0
            self.landmarks = []
        }
    }

    // MARK: - Action
    public enum Action: Equatable {
        case calculate
        case onChangeCoordinate(CLLocationCoordinate2D)
        case onChangeDegrees(CLLocationDirection)
    }

    // MARK: - Dependency
    @Dependency(\.locationManager)
    private var locationManager: LocationManager

    public init() {}

    // MARK: - Reducer
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .calculate:
                state.distanceToGoal = state.coordinate.distance(from: state.goal)
                state.directionToGoal = state.coordinate.directionDelta(
                    from: state.goal,
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
