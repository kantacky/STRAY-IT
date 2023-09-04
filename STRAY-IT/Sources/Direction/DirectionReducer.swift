import ComposableArchitecture
import CoreLocation
import Dependency
import SharedModel

public struct DirectionReducer: Reducer {
    @Dependency(\.locationManager)
    private var locationManager: LocationManager

    public enum CancelID {
        case coordinateSubscription, degreesSubscription
    }

    public init() {}

    public struct State: Equatable {
        public var currentLocation: CLLocationCoordinate2D
        public var headingDirection: CLLocationDirection
        public var goal: CLLocationCoordinate2D
        public var distanceToGoal: Double
        public var directionToGoal: Double
        public var landmarks: [Landmark]

        public init(
            currentCoordinate: CLLocationCoordinate2D = .init(latitude: 0, longitude: 0),
            headingDirection: Double = 0,
            goal: CLLocationCoordinate2D = .init(latitude: 0, longitude: 0),
            landmarks: [Landmark] = []
        ) {
            self.currentLocation = currentCoordinate
            self.headingDirection = headingDirection
            self.goal = goal
            self.distanceToGoal = 0
            self.directionToGoal = 0
            self.landmarks = landmarks
        }
    }

    public enum Action: Equatable {
        case onAppear
        case subscribeCoordinate
        case subscribeDegrees
        case onChangeCoordinate(CLLocationCoordinate2D)
        case onChangeDegrees(CLLocationDirection)
        case calculate
    }

    public func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .onAppear:
            if let data = UserDefaults.standard.data(forKey: "goal"),
               let goal = try? JSONDecoder().decode(CLLocationCoordinate2D.self, from: data) {
                state.goal = goal
            }
            return .run { send in
                Task.detached {
                    await send(.subscribeCoordinate)
                }
                Task.detached {
                    await send(.subscribeDegrees)
                }
                await send(.calculate)
            }

        case .subscribeCoordinate:
            return .run { send in
                for await value in locationManager.coordinate {
                    Task.detached { @MainActor in
                        send(.onChangeCoordinate(value))
                    }
                }
            }
            .cancellable(id: CancelID.coordinateSubscription)

        case .subscribeDegrees:
            return .run { send in
                for await value in locationManager.degrees {
                    Task.detached { @MainActor in
                        send(.onChangeDegrees(value))
                    }
                }
            }
            .cancellable(id: CancelID.degreesSubscription)

        case let .onChangeCoordinate(coordinate):
            state.currentLocation = coordinate
            return .run { send in
                await send(.calculate)
            }

        case let .onChangeDegrees(direction):
            state.headingDirection = direction
            return .run { send in
                await send(.calculate)
            }

        case .calculate:
            state.distanceToGoal = LocationLogic.getDistance(originLC: state.currentLocation, targetLC: state.goal)
            state.directionToGoal = LocationLogic.getDirectionDelta(state.currentLocation, state.goal, heading: state.headingDirection)
            return .none
        }
    }
}
