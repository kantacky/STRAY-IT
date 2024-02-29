import Dependencies

extension LocationManager: DependencyKey {
    public static let liveValue: LocationManager = .init()
}

extension LocationManager: TestDependencyKey {
    public static let testValue: LocationManager = unimplemented()
}
