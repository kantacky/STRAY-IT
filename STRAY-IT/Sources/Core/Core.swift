import ComposableArchitecture
import CoreLocation
import LocationManager
import Models
import Navigation
import Search
import Tutorial
import UserDefaultsClient

@Reducer
public struct Core {
    @Reducer
    public enum Scene {
        case launch
        case tutorial(Tutorial)
        case search(Search)
        case navigation(ComposedReducer)
    }

    // MARK: - State
    @ObservableState
    public struct State {
        @Presents var alert: AlertState<Action.Alert>?
        var scene: Scene.State

        public init() {
            self.scene = .launch
        }
    }

    // MARK: - Action
    public enum Action {
        case alert(PresentationAction<Alert>)
        case onAppear
        case scene(Scene.Action)

        public enum Alert {}
    }

    // MARK: - Dependency
    @Dependency(LocationManager.self) private var locationManager
    @Dependency(UserDefaultsClient.self) private var userDefaultsClient

    public init() {}

    // MARK: - Reducer
    public var body: some Reducer<State, Action> {
        Scope(state: \.scene, action: \.scene) {
            Scene.body
        }

        Reduce { state, action in
            switch action {
            case .alert:
                return .none

            case .onAppear:
                if !userDefaultsClient.boolForKey("hasShownTutorial") {
                    _ = self.locationManager.requestWhenInUseAuthorization()
                    state.scene = .tutorial(Tutorial.State())
                    return .none
                }

                if !self.locationManager.requestWhenInUseAuthorization() {
                    state.alert = AlertState(
                        title: TextState("Something Went Wrong while Getting Your Location."),
                        message: TextState("Allow us to use your location service.")
                    )
                }
                state.scene = .search(Search.State())
                return .none

            case .scene(.tutorial(.onSearchButtonTapped)):
                state.scene = .search(.init())
                return .run { _ in
                    await userDefaultsClient.setBool(true, "hasShownTutorial")
                }

            case let .scene(.search(.querySearchResponse(.failure(error)))):
                state.alert = AlertState(
                    title: TextState("Something Went Wrong while Searching."),
                    message: TextState(error.localizedDescription)
                )
                return .none

            case let .scene(.search(.onSelectResult(item))):
                if let start: CLLocationCoordinate2D = self.locationManager.getCoordinate() {
                    let goal: CLLocationCoordinate2D = item.placemark.coordinate
                    state.scene = .navigation(.init(start: start, goal: goal))
                    return .none
                }
                state.scene = .search(Search.State())
                state.alert = AlertState(
                    title: TextState("Something Went Wrong while Getting Your Location."),
                    message: TextState("Please try again.")
                )
                return .none

            case .scene(.navigation(.onSearchButtonTapped)):
                state.scene = .search(Search.State())
                return .none

            case .scene:
                return .none
            }
        }
        .ifLet(\.$alert, action: \.alert)
    }
}
