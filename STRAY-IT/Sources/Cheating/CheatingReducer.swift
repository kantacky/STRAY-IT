import ComposableArchitecture
import _MapKit_SwiftUI
import SharedLogic
import SharedModel

public struct CheatingReducer: ReducerProtocol {
    public init() {}

    public struct State: Equatable {
        public var postion: MapCameraPosition
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
            self.postion = .region(LocationLogic.getRegion(coordinates: allPoints))
        }
    }

    public enum Action: Equatable {
        case onAppear
        case onChangePosition(MapCameraPosition)
        case onPointAppended(CLLocationCoordinate2D)
    }

    public func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .onAppear:
            var allPoints: [CLLocationCoordinate2D] = [state.start, state.goal]
            allPoints.append(contentsOf: state.points)
            state.postion = .region(LocationLogic.getRegion(coordinates: allPoints))
            return .none

        case let .onChangePosition(position):
            state.postion = position
            return .none

        case let .onPointAppended(point):
            state.points.append(point)
            var allPoints: [CLLocationCoordinate2D] = [state.start, state.goal]
            allPoints.append(contentsOf: state.points)
            state.postion = .region(LocationLogic.getRegion(coordinates: allPoints))
            return .none
        }
    }
}
