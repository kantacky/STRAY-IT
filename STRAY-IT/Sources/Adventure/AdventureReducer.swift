import _MapKit_SwiftUI
import ComposableArchitecture
import Dependency
import SharedModel

public struct AdventureReducer: Reducer {
    @Dependency(\.locationManager)
    private var locationManager: LocationManager
    @Dependency(\.userDefaults)
    private var userDefaults: UserDefaultsClient

    public init() {}

    public struct State: Equatable {
        public var position: MapCameraPosition
        public var coordinate: CLLocationCoordinate2D
        public var degrees: CLLocationDirection
        public var start: CLLocationCoordinate2D
        public var goal: CLLocationCoordinate2D

        public init(
            coordinate: CLLocationCoordinate2D = .init(latitude: 0, longitude: 0),
            degrees: CLLocationDirection = 0,
            start: CLLocationCoordinate2D = .init(latitude: 0, longitude: 0),
            goal: CLLocationCoordinate2D = .init(latitude: 0, longitude: 0)
        ) {
            self.coordinate = coordinate
            self.degrees = degrees
            self.start = start
            self.goal = goal
            self.position = .region(LocationLogic.getRegion(coordinates: [start, goal]))
        }
    }

    public enum Action: Equatable {
        case onAppear
        case onChangePosition(MapCameraPosition)
        case onChangeCoordinate(CLLocationCoordinate2D)
        case onChangeDegrees(CLLocationDirection)
    }

    public func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .onAppear:
            state.position = .region(LocationLogic.getRegion(coordinates: [state.start, state.goal]))
            if let coordinate: CLLocationCoordinate2D = try? userDefaults.customType(forKey: UserDefaultsKeys.start) {
                if coordinate != state.start {
                    state.start = coordinate
                }
            }
            if let coordinate: CLLocationCoordinate2D = try? userDefaults.customType(forKey: UserDefaultsKeys.goal) {
                if coordinate != state.goal {
                    state.goal = coordinate
                }
            }
            return .none

        case let .onChangePosition(position):
            state.position = position
            return .none

        case let .onChangeCoordinate(coordinate):
            state.coordinate = coordinate
            return .none

        case let .onChangeDegrees(degrees):
            state.degrees = degrees
            return .none
        }
    }
}
