import Dependencies

extension LocationManager: TestDependencyKey {
    public static let testValue: LocationManager = .init()
}
