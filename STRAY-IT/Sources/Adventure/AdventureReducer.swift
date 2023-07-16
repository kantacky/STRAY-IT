import ComposableArchitecture
import _MapKit_SwiftUI
import SharedLogic
import SharedModel

public struct AdventureReducer: ReducerProtocol {
    public init() {}

    public struct State: Equatable {
        public var postion: MapCameraPosition
        public var start: CLLocationCoordinate2D
        public var goal: CLLocationCoordinate2D

        public init(
            start: CLLocationCoordinate2D = .init(latitude: 0, longitude: 0),
            goal: CLLocationCoordinate2D = .init(latitude: 0, longitude: 0)
        ) {
            self.start = start
            self.goal = goal
            self.postion = .region(LocationLogic.getRegion(coordinates: [start, goal]))
        }
    }

    public enum Action: Equatable {
        case onAppear
        case onChangePosition(MapCameraPosition)
    }

    public func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .onAppear:
            state.postion = .region(LocationLogic.getRegion(coordinates: [state.start, state.goal]))
            return .none

        case let .onChangePosition(position):
            state.postion = position
            return .none
        }
    }
}
