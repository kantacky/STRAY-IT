import ComposableArchitecture
import CoreLocation
import SharedLogic
import SharedModel

public struct DirectionReducer: ReducerProtocol {
    public init() {}

    public struct State: Equatable {
        public var currentLocation: CLLocationCoordinate2D?
        public var headingDirection: CLLocationDirection?
        public var goal: CLLocationCoordinate2D
        public var distanceToGoal: Double
        public var directionToGoal: Double
        public var landmarks: [Landmark]

        public init(
            currentCoordinate: CLLocationCoordinate2D? = nil,
            headingDirection: Double? = nil,
            goal: CLLocationCoordinate2D = .init(latitude: 0, longitude: 0),
            landmarks: [Landmark] = []
        ) {
            self.currentLocation = currentCoordinate
            self.headingDirection = headingDirection
            self.goal = goal
            if let currentCoordinate = self.currentLocation,
               let headingDirection = self.headingDirection {
                self.distanceToGoal = LocationLogic.getDistance(originLC: currentCoordinate, targetLC: self.goal)
                self.directionToGoal = LocationLogic.getDirectionDelta(currentCoordinate, self.goal, heading: headingDirection)
            } else {
                self.distanceToGoal = 0
                self.directionToGoal = 0
            }
            self.landmarks = landmarks
        }
    }

    public enum Action: Equatable {
        case onAppear
        case onUpdateLocation(CLLocationCoordinate2D)
        case onUpdateHeading(CLLocationDirection)
        case calculate
    }

    public func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .onAppear:
            return .run { send in
                await send(.calculate)
            }

        case let .onUpdateLocation(coordinate):
            state.currentLocation = coordinate
            return .run { send in
                await send(.calculate)
            }

        case let .onUpdateHeading(direction):
            state.headingDirection = direction
            return .run { send in
                await send(.calculate)
            }

        case .calculate:
            if let currentCoordinate = state.currentLocation,
               let headingDirection = state.headingDirection {
                state.distanceToGoal = LocationLogic.getDistance(originLC: currentCoordinate, targetLC: state.goal)
                state.directionToGoal = LocationLogic.getDirectionDelta(currentCoordinate, state.goal, heading: headingDirection)
            } else {
                state.distanceToGoal = 0
                state.directionToGoal = 0
            }
            return .none
        }
    }
}
