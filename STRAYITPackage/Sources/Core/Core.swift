import ComposableArchitecture
import CoreLocation
import LocationClient
import Search
import STRAYITEntity
import STRAYITNavigation
import Tutorial
import UserDefaultsClient

@Reducer
public struct Core {
    @Reducer(state: .equatable)
    public enum Scene {
        case launch
        case tutorial(Tutorial)
        case search(Search)
        case navigation(STRAYITNavigation)
    }

    // MARK: - State
    @ObservableState
    public struct State: Equatable {
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

        public enum Alert: Equatable {}
    }

    // MARK: - Dependency
    @Dependency(LocationClient.self) private var locationClient
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
                do {
                    try locationClient.requestWhenInUseAuthorization()
                    if userDefaultsClient.boolForKey("hasShownTutorial") {
                        state.scene = .search(Search.State())
                    } else {
                        state.scene = .tutorial(Tutorial.State())
                    }
                } catch {
                    state.alert = AlertState(
                        title: TextState("Something Went Wrong while Getting Your Location."),
                        message: TextState("Allow us to use your location service.")
                    )
                }
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
                do {
                    let start = try locationClient.getCoordinate()
                    let goal = item.placemark.coordinate
                    state.scene = .navigation(.init(start: start, goal: goal))
                } catch {
                    state.scene = .search(Search.State())
                    state.alert = AlertState(
                        title: TextState("Something Went Wrong."),
                        message: TextState(error.localizedDescription)
                    )
                }
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
