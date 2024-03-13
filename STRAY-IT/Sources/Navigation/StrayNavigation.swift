import Adventure
import Cheating
import Combine
import ComposableArchitecture
import CoreLocation
import Direction
import Entity
import Foundation
import LocationClient
import MapKit

@Reducer
public struct StrayNavigation {
    // MARK: - State
    @ObservableState
    public struct State: Equatable {
        var tabSelection = TabItem.direction
        var coordinate: CLLocationCoordinate2D?
        var degrees: CLLocationDirection?
        var start: CLLocationCoordinate2D
        var goal: CLLocationCoordinate2D
        var direction: Direction.State
        var cheating: Cheating.State

        public init(
            start: CLLocationCoordinate2D,
            goal: CLLocationCoordinate2D
        ) {
            self.start = start
            self.goal = goal
            self.direction = Direction.State(start: start, goal: goal)
            self.cheating = Cheating.State(start: start, goal: goal)
        }
    }

    // MARK: - Action
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case onAppear
        case onChangeCoordinate(CLLocationCoordinate2D)
        case onChangeDegrees(CLLocationDirection)
        case onSearchButtonTapped
        case direction(Direction.Action)
        case cheating(Cheating.Action)
    }

    // MARK: - Dependency
    @Dependency(LocationClient.self) private var locationClient

    public enum CancelID {
        case coordinateSubscription
        case degreesSubscription
    }

    public init() {}

    // MARK: - Reducer
    public var body: some Reducer<State, Action> {
        Scope(state: \.direction, action: \.direction) {
            Direction()
        }
        Scope(state: \.cheating, action: \.cheating) {
            Cheating()
        }

        BindingReducer()

        Reduce { state, action in
            switch action {
            case .binding:
                return .none

            case .onAppear:
                locationClient.startUpdatingLocation()
                locationClient.enableBackgroundLocationUpdates()
                return .merge(
                    .run { send in
                        for await value in locationClient.getCoordinateStream() {
                            await send(.onChangeCoordinate(value))
                        }
                    }.cancellable(id: CancelID.coordinateSubscription),
                    .run { send in
                        for await value in locationClient.getDegreesStream() {
                            await send(.onChangeDegrees(value))
                        }
                    }.cancellable(id: CancelID.degreesSubscription)
                )

            case let .onChangeCoordinate(coordinate):
                return .run { send in
                    await send(.direction(.onChangeCoordinate(coordinate)))
                    await send(.cheating(.onChangeCoordinate(coordinate)))
                }

            case let .onChangeDegrees(degrees):
                return .run { send in
                    await send(.direction(.onChangeDegrees(degrees)))
                    await send(.cheating(.onChangeDegrees(degrees)))
                }

            case .onSearchButtonTapped:
                Task.cancel(id: CancelID.coordinateSubscription)
                Task.cancel(id: CancelID.degreesSubscription)
                locationClient.disableBackgroundLocationUpdates()
                locationClient.stopUpdatingLocation()
                return .none

            case .direction:
                return .none

            case .cheating:
                return .none
            }
        }
    }
}
