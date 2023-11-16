import _MapKit_SwiftUI
import ComposableArchitecture
import Models

public struct CheatingReducer: Reducer {
    // MARK: - State
    public struct State: Equatable {
        var position: MapCameraPosition
        var coordinate: CLLocationCoordinate2D
        var degrees: CLLocationDirection
        var start: CLLocationCoordinate2D
        var goal: CLLocationCoordinate2D
        var points: [CLLocationCoordinate2D]

        public init(
            start: CLLocationCoordinate2D,
            goal: CLLocationCoordinate2D
        ) {
            self.coordinate = start
            self.degrees = 0
            self.start = start
            self.goal = goal
            self.points = [start]
            self.position = .region(.getRegion(from: [start, goal]))
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
                state.position = .region(.getRegion(from: state.points + [state.goal]))
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
