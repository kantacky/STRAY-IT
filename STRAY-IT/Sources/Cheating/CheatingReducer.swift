import _MapKit_SwiftUI
import ComposableArchitecture
import LocationManager
import SharedModel

public struct CheatingReducer: Reducer {
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
            coordinate: CLLocationCoordinate2D = .init(latitude: 0, longitude: 0),
            degrees: CLLocationDirection = 0,
            start: CLLocationCoordinate2D = .init(latitude: 0, longitude: 0),
            goal: CLLocationCoordinate2D = .init(latitude: 0, longitude: 0),
            points: [CLLocationCoordinate2D] = []
        ) {
            self.coordinate = coordinate
            self.degrees = degrees
            self.start = start
            self.goal = goal
            self.points = points
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

        case .onResetPosition:
            return .run { [state] send in
                var allPoints: [CLLocationCoordinate2D] = [state.start, state.goal]
                allPoints.append(contentsOf: state.points)
                await send(.onChangePosition(.region(LocationLogic.getRegion(coordinates: allPoints))))
            }

        case let .onChangeCoordinate(coordinate):
            state.coordinate = coordinate
            return .none

        case let .onChangeDegrees(degrees):
            state.degrees = degrees
            return .none
        }
    }
}
