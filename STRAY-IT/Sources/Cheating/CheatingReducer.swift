import ComposableArchitecture
import ComposableCoreLocation
import Dependency
import ExtendedMKModels
import MapKit
import SharedLogic

public struct CheatingReducer: ReducerProtocol {
    @Dependency(\.userDefaults)
    private var userDefaults: UserDefaultsClient
    @Dependency(\.locationManager)
    private var locationManager: LocationManager

    public init() {}

    public struct State: Equatable {
        public var currentLocation: CLLocationCoordinate2D?
        public var region: MKCoordinateRegion?
        public var annotations: [Annotation]
        public var pathPoints: [CLLocationCoordinate2D]

        public init(
            region: MKCoordinateRegion? = nil,
            annotations: [Annotation] = [],
            pathPoints: [CLLocationCoordinate2D] = []
        ) {
            self.region = region
            self.annotations = annotations
            self.pathPoints = pathPoints
        }
    }

    public enum Action: Equatable {
        case onAppear

        case setStartAndGoal
        case setRegion(MKCoordinateRegion?)
        case setAnnotations([Annotation])
        case setPathPoints([CLLocationCoordinate2D])
        case locationManager(LocationManager.Action)
    }

    public func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .onAppear:
            if state.annotations.count < 2 || state.pathPoints.count < 1 {
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
                state.pathPoints = [
                    start.coordinate
                ]
            } else {
                state.annotations = []
                state.pathPoints = []
            }
            return .none

        case let .setRegion(region):
            state.region = region
            return .none

        case let .setAnnotations(annotations):
            state.annotations = annotations
            return .none

        case let .setPathPoints(pathPoints):
            state.pathPoints = pathPoints
            return .none

        case let .locationManager(.didUpdateLocations(locations)):
            guard let location: Location = locations.first else {
                return .none
            }
            state.currentLocation = location.coordinate
            state.pathPoints.append(location.coordinate)
            if state.pathPoints.count < 2 {
                state.region = MKCoordinateRegion(
                    center: location.coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                )
            } else {
                state.region = LocationLogic.getRegion(coordinates: state.pathPoints)
            }
            return .none

        default:
            return .none
        }
    }
}
