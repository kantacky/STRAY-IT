import ComposableArchitecture
import ComposableCoreLocation
import Dependency
import ExtendedMKModels
import MapKit

public struct AdventureReducer: ReducerProtocol {
    @Dependency(\.userDefaults)
    private var userDefaults: UserDefaultsClient
    @Dependency(\.locationManager)
    private var locationManager: LocationManager

    public init() {}

    public struct State: Equatable {
        public var isLoading: Bool
        public var currentLocation: CLLocationCoordinate2D?
        public var region: MKCoordinateRegion?
        public var annotations: [Annotation]

        public init(
            region: MKCoordinateRegion? = nil,
            annotations: [Annotation] = []
        ) {
            self.isLoading = false
            self.region = region
            self.annotations = annotations
        }
    }

    public enum Action: Equatable {
        case onAppear
        case setStartAndGoal
        case setRegion(MKCoordinateRegion?)
        case setAnnotations([Annotation])
        case locationManager(LocationManager.Action)
    }

    public func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .onAppear:
            if state.annotations.count < 2 {
                return .task { .setStartAndGoal }
            }
            return .none

        case .setStartAndGoal:
            if let start: Annotation = try? userDefaults.customType(forKey: UserDefaultsKeys.start),
               let goal: Annotation = try? userDefaults.customType(forKey: UserDefaultsKeys.goal) {
                state.annotations = [
                    Annotation(coordinate: start.coordinate),
                    Annotation(coordinate: goal.coordinate)
                ]
            } else {
                state.annotations = []
            }
            return .none

        case let .setRegion(region):
            state.region = region
            return .none

        case let .setAnnotations(annotations):
            state.annotations = annotations
            return .none

        case let .locationManager(.didUpdateLocations(locations)):
            guard let location: Location = locations.first else {
                return .none
            }
            state.currentLocation = location.coordinate
            state.region = MKCoordinateRegion(
                center: location.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )
            return .none

        default:
            return .none
        }
    }
}
