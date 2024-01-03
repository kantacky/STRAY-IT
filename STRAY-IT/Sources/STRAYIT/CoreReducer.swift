import ComposableArchitecture
import CoreLocation
import LocationManager
import Models
import Navigation
import Search
import Tutorial
import UserDefaultsClient

@Reducer
struct CoreReducer {
    // MARK: - State
    struct State: Equatable {
        @PresentationState var alert: AlertState<Action.Alert>?
        var scene: Scene

        init() {
            self.scene = .launch
        }

        @CasePathable
        enum Scene: Equatable {
            case launch
            case tutorial(TutorialReducer.State)
            case search(SearchReducer.State)
            case navigation(ComposedReducer.State)
        }
    }

    // MARK: - Action
    enum Action: Equatable {
        case onAppear
        case alert(PresentationAction<Alert>)
        case tutorial(TutorialReducer.Action)
        case search(SearchReducer.Action)
        case navigation(ComposedReducer.Action)

        enum Alert: Equatable {}
    }

    // MARK: - Dependency
    @Dependency(\.locationManager)
    private var locationManager: LocationManager
    @Dependency(\.userDefaultsClient)
    private var userDefaultsClient: UserDefaultsClient

    init() {}

    // MARK: - Reducer
    var body: some Reducer<State, Action> {
        Scope(state: \.scene, action: .self) {
            Scope(state: \.tutorial, action: \.tutorial) {
                TutorialReducer()
            }

            Scope(state: \.search, action: \.search) {
                SearchReducer()
            }

            Scope(state: \.navigation, action: \.navigation) {
                ComposedReducer()
            }
        }

        Reduce { state, action in
            switch action {
            case .onAppear:
                if self.locationManager.requestWhenInUseAuthorization() {
                    if self.userDefaultsClient.boolForKey("hasShownTutorial") {
                        state.scene = .search(.init())
                    } else {
                        state.scene = .tutorial(.init())
                    }
                } else {
                    state.alert = .init(title: {
                        .init("Allow us to use your location service")
                    })
                }
                return .none

            case .tutorial(.onSearchButtonTapped):
                state.scene = .search(.init())
                return .run { _ in
                    await self.userDefaultsClient.setBool(true, "hasShownTutorial")
                }

            case let .search(.querySearchResponse(.failure(error))):
                state.alert = .init(title: {
                    .init(error.localizedDescription)
                })
                return .none

            case let .search(.onSelectResult(item)):
                if let start: CLLocationCoordinate2D = self.locationManager.getCoordinate() {
                    let goal: CLLocationCoordinate2D = item.placemark.coordinate
                    state.scene = .navigation(.init(start: start, goal: goal))
                    self.locationManager.enableBackgroundLocationUpdates()
                    return .none
                }
                state.scene = .search(.init())
                state.alert = .init(title: {
                    .init("Failed to get current location")
                })
                return .none

            case .navigation(.onSearchButtonTapped):
                self.locationManager.disableBackgroundLocationUpdates()
                state.scene = .search(.init())
                return .none

            case .alert:
                return .none

            case .tutorial:
                return .none

            case .search:
                return .none

            case .navigation:
                return .none
            }
        }
        .ifLet(\.$alert, action: \.alert)
    }
}
