import _MapKit_SwiftUI
import ComposableArchitecture
import Dependency
import SharedModel

public struct AdventureReducer: Reducer {
    @Dependency(\.locationManager)
    private var locationManager: LocationManager

    public init() {}

    public struct State: Equatable {
        public var position: MapCameraPosition
        public var start: CLLocationCoordinate2D
        public var goal: CLLocationCoordinate2D

        public init(
            start: CLLocationCoordinate2D = .init(latitude: 0, longitude: 0),
            goal: CLLocationCoordinate2D = .init(latitude: 0, longitude: 0)
        ) {
            self.start = start
            self.goal = goal
            self.position = .region(LocationLogic.getRegion(coordinates: [start, goal]))
        }
    }

    public enum Action: Equatable {
        case onAppear
        case onChangePosition(MapCameraPosition)
    }

    public func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .onAppear:
            state.position = .region(LocationLogic.getRegion(coordinates: [state.start, state.goal]))
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
        }
    }
}
