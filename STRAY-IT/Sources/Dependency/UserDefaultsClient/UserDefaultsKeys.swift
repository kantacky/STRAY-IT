import CoreLocation
import ExtendedMKModels

extension UserDefaultsKeys {
    /// HasShowTutorial
    public static let hasShownTutorial: UserDefaultsKey<Bool> = .init(
        name: "hasShownTutorial",
        defaultValue: false
    )

    /// CurrentLocation
    public static let currentLocation: UserDefaultsKey<CLLocationCoordinate2D> = .init(
        name: "currentLocation",
        defaultValue: .init(latitude: 0.0, longitude: 0.0)
    )

    /// Start
    public static let start: UserDefaultsKey<Annotation?> = .init(
        name: "start",
        defaultValue: nil
    )

    /// Goal
    public static let goal: UserDefaultsKey<Annotation?> = .init(
        name: "goal",
        defaultValue: nil
    )
}
