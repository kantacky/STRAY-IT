import CoreLocation

extension UserDefaultsKeys {
    /// HasShowTutorial
    public static let hasShownTutorial: UserDefaultsKey<Bool> = .init(
        name: "hasShownTutorial",
        defaultValue: false
    )
}
