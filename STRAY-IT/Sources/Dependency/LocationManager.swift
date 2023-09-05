import Dependencies
import SharedModel

public enum LocationManagerKey: DependencyKey, TestDependencyKey {
    public static let liveValue: LocationManager = .init()
    public static let testValue: LocationManager = .init()
}

extension DependencyValues {
    /// LocationManager
    public var locationManager: LocationManager {
        get { self[LocationManagerKey.self] }
        set { self[LocationManagerKey.self] = newValue }
    }
}
