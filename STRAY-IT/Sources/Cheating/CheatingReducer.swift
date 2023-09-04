import _MapKit_SwiftUI
import ComposableArchitecture
import Dependency
import SharedModel

public struct CheatingReducer: Reducer {
    @Dependency(\.locationManager)
    private var locationManager: LocationManager

    public init() {}

    public struct State: Equatable {
        public var position: MapCameraPosition
        public var start: CLLocationCoordinate2D
        public var goal: CLLocationCoordinate2D
        public var points: [CLLocationCoordinate2D]

        public init(
            start: CLLocationCoordinate2D = .init(latitude: 0, longitude: 0),
            goal: CLLocationCoordinate2D = .init(latitude: 0, longitude: 0),
            points: [CLLocationCoordinate2D] = []
        ) {
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
        case onAppendPoint(CLLocationCoordinate2D)
    }

    public func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .onAppear:
            var allPoints: [CLLocationCoordinate2D] = [state.start, state.goal]
            allPoints.append(contentsOf: state.points)
            state.position = .region(LocationLogic.getRegion(coordinates: allPoints))
            if let data = UserDefaults.standard.data(forKey: "start"),
               let start = try? JSONDecoder().decode(CLLocationCoordinate2D.self, from: data) {
                state.start = start
            }
            if let data = UserDefaults.standard.data(forKey: "goal"),
               let goal = try? JSONDecoder().decode(CLLocationCoordinate2D.self, from: data) {
                state.goal = goal
            }
            return .none

        case let .onChangePosition(position):
            state.position = position
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
