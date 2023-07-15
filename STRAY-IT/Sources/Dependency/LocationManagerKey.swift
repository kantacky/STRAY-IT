import ComposableCoreLocation
import Dependencies

public enum LocationManagerKey: DependencyKey {
    public static let liveValue: LocationManager = .live
    public static let testValue: LocationManager = .failing
}

extension DependencyValues {
    /// DependencyValue of LocationManager
    public var locationManager: LocationManager {
        get { self[LocationManagerKey.self] }
        set { self[LocationManagerKey.self] = newValue }
    }
}
