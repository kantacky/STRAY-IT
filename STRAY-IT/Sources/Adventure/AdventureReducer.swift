import _MapKit_SwiftUI
import ComposableArchitecture
import LocationManager
import SharedModel

public struct AdventureReducer: Reducer {
    @Dependency(\.locationManager)
    private var locationManager: LocationManager

    public init() {}

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
            self.coordinate = .init(latitude: 0, longitude: 0)
            self.degrees = 0
            self.start = start
            self.goal = goal
            self.points = []
            var allPoints: [CLLocationCoordinate2D] = [self.start, self.goal]
            allPoints.append(contentsOf: self.points)
            self.position = .region(LocationLogic.getRegion(coordinates: allPoints))
        }
    }

    public enum Action: Equatable {
        case onAppear
        case onChangePosition(MapCameraPosition)
        case onChangeCoordinate(CLLocationCoordinate2D)
        case onChangeDegrees(CLLocationDirection)
        case onAppendPoint(CLLocationCoordinate2D)
        case onResetPosition
    }

    public func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .onAppear:
            return .run { send in
                await send(.onResetPosition)
            }

        case let .onChangePosition(position):
            state.position = position
            return .none

        case let .onChangeCoordinate(coordinate):
            state.coordinate = coordinate
            return .run { send in
                await send(.onAppendPoint(coordinate))
            }

        case .onResetPosition:
            return .run { [state] send in
                var allPoints: [CLLocationCoordinate2D] = [state.start, state.goal]
                allPoints.append(contentsOf: state.points)
                await send(.onChangePosition(.region(LocationLogic.getRegion(coordinates: allPoints))))
            }

        case let .onChangeDegrees(degrees):
            state.degrees = degrees
            return .none

        case let .onAppendPoint(point):
            state.points.append(point)
            var allPoints: [CLLocationCoordinate2D] = [state.start, state.goal]
            allPoints.append(contentsOf: state.points)
            state.position = .region(LocationLogic.getRegion(coordinates: allPoints))
            return .none
        }
    }
}
