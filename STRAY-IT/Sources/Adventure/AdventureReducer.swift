import ComposableArchitecture
import MapKit
import SharedModel

public struct AdventureReducer: ReducerProtocol {
    public init() {}

    public struct State: Equatable {
        public var start: CLLocationCoordinate2D
        public var goal: CLLocationCoordinate2D

        public init(
            start: CLLocationCoordinate2D = .init(latitude: 0, longitude: 0),
            goal: CLLocationCoordinate2D = .init(latitude: 0, longitude: 0)
        ) {
            self.start = start
            self.goal = goal
        }
    }

    public enum Action: Equatable {
        case onAppear
    }

    public func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .onAppear:
            return .none
        }
    }
}
