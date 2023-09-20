import Dependencies

extension DependencyValues {
    /// LocationManager
    public var locationManager: LocationManager {
        get { self[LocationManager.self] }
        set { self[LocationManager.self] = newValue }
    }
}
