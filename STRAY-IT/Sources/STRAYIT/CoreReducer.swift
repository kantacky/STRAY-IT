import ComposableArchitecture
import Navigation
import CoreLocation
import LocationManager
import Search
import Models

struct CoreReducer: Reducer {
    // MARK: - State
    struct State: Equatable {
        enum Status: Equatable {
            case search(SearchReducer.State)
            case navigation(ComposedReducer.State)
        }

        @PresentationState var alert: AlertState<AlertAction>?
        var status: Status

        init() {
            self.status = .search(.init())
        }
    }

    // MARK: - Action
    enum Action: Equatable {
        case onAppear
        case alert(PresentationAction<AlertAction>)
        case setAlert(String)
        case search(SearchReducer.Action)
        case navigation(ComposedReducer.Action)
    }

    enum AlertAction: Equatable {}

    // MARK: - Dependency
    @Dependency(\.locationManager)
    private var locationManager: LocationManager

    init() {}

    // MARK: - Reducer
    var body: some Reducer<State, Action> {
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
            case .onAppear:
                if self.locationManager.requestWhenInUseAuthorization() {
                    return .none
                } else if self.locationManager.isValidAuthoriztionStatus() {
                    return .none
                }

                return .run { send in
                    await send(.setAlert("Allow us to use your location service"))
                }

            case let .setAlert(message):
                state.alert = AlertState {
                    TextState(message)
                }
                return .none

            case let .search(.querySearchResponse(.failure(error))):
                return .run { send in
                    await send(.setAlert(error.localizedDescription))
                }

            case let .search(.onSelectResult(item)):
                if let start: CLLocationCoordinate2D = self.locationManager.getCoordinate() {
                    let goal: CLLocationCoordinate2D = item.placemark.coordinate
                    state.status = .navigation(.init(start: start, goal: goal))
                    return .none
                }
                state.status = .search(.init())
                return .run { send in
                    await send(.setAlert("Failed to get current location"))
                }

            case .navigation(.onSearchButtonTapped):
                state.status = .search(.init())
                return .none

            default:
                return .none
            }
        }
        .ifLet(\.$alert, action: /Action.alert)
    }
}
