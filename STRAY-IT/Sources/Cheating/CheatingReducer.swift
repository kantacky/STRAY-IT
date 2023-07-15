import ComposableArchitecture
import MapKit
import SharedLogic
import SharedModel

public struct CheatingReducer: ReducerProtocol {
    public init() {}

    public struct State: Equatable {
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
