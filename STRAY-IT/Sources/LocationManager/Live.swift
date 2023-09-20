import Dependencies

extension LocationManager: DependencyKey {
    public static let liveValue: LocationManager = .init()
}
