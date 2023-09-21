import ComposableArchitecture
import Composed
import CoreLocation
import LocationManager
import Search
import SharedModel

public struct CoreReducer: Reducer {
    // MARK: - State
    public struct State: Equatable {
        public enum Status: Equatable {
            case search(SearchReducer.State)
            case navigation(ComposedReducer.State)
        }

        @PresentationState var alert: AlertState<Action.Alert>?
        public var status: Status

        public init() {
            self.status = .search(.init())
        }
    }

    // MARK: - Action
    public enum Action: Equatable {
        case alert(PresentationAction<Alert>)
        case setAlert(String, String)
        case alertDismissed
        case onResetStartAndGoal
        case search(SearchReducer.Action)
        case navigation(ComposedReducer.Action)

        public enum Alert: Equatable {
            case incrementButtonTapped
        }
    }

    // MARK: - Dependency
    @Dependency(\.locationManager)
    private var locationManager: LocationManager

    public init() {}

    // MARK: - Reducer
    public var body: some Reducer<State, Action> {
        Scope(state: \.status, action: .self) {
            Scope(state: /State.Status.search, action: /Action.search) {
                SearchReducer()
            }
            Scope(state: /State.Status.navigation, action: /Action.navigation) {
                ComposedReducer()
            }
        }

        Reduce { state, action in
            switch action {
            case let .setAlert(title, message):
                state.alert = AlertState {
                    TextState(title)
                } actions: {
                    ButtonState(role: .cancel) {
                        TextState("OK")
                    }
                } message: {
                    TextState(message)
                }
                return .none

            case .alertDismissed:
                state.alert = nil
                return .none

            case let .search(.onSelectResult(item)):
                if let start: CLLocationCoordinate2D = self.locationManager.getCoordinate() {
                    let goal: CLLocationCoordinate2D = item.placemark.coordinate
                    state.status = .navigation(.init(start: start, goal: goal))
                    return .none
                }
                return .run { send in
                    await send(.setAlert("Failed to get current location", ""))
                }

            case .navigation(.onSearchButtonTapped):
                state.status = .search(.init())
                return .none

            default:
                return .none
            }
        }
    }
}
