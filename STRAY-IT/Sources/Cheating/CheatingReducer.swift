import _MapKit_SwiftUI
import ComposableArchitecture
import SharedModel

public struct CheatingReducer: Reducer {
    // MARK: - State
    public struct State: Equatable {
        public var position: MapCameraPosition
        public var coordinate: CLLocationCoordinate2D
        public var degrees: CLLocationDirection
        public var start: CLLocationCoordinate2D
        public var goal: CLLocationCoordinate2D
        public var points: [CLLocationCoordinate2D]

        public init(
            start: CLLocationCoordinate2D,
            goal: CLLocationCoordinate2D
        ) {
            self.coordinate = start
            self.degrees = 0
            self.start = start
            self.goal = goal
            self.points = [start]
            self.position = .region(LocationLogic.getRegion(coordinates: [start, goal]))
        }
    }

    // MARK: - Action
    public enum Action: Equatable {
        case onChangePosition(MapCameraPosition)
        case appendPoint(CLLocationCoordinate2D)
        case onChangeCoordinate(CLLocationCoordinate2D)
        case onChangeDegrees(CLLocationDirection)
    }

    // MARK: - Dependency

    public init() {}

    // MARK: - Reducer
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .onChangePosition(position):
                state.position = position
                return .none

            case let .appendPoint(point):
                state.points.append(point)
                state.position = .region(LocationLogic.getRegion(
                    coordinates: state.points + [state.goal]
                ))
                return .none

            case let .onChangeCoordinate(coordinate):
                state.coordinate = coordinate
                return .run { send in
                    await send(.appendPoint(coordinate))
                }

            case let .onChangeDegrees(degrees):
                state.degrees = degrees
                return .none
            }
        }
    }
}
