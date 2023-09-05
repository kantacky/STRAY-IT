import CoreLocation
import SharedModel

extension UserDefaultsKeys {
    public static let start: UserDefaultsKey<CLLocationCoordinate2D> = .init(
        name: "start",
        defaultValue: .init()
    )
    public static let goal: UserDefaultsKey<CLLocationCoordinate2D> = .init(
        name: "goal",
        defaultValue: .init()
    )
}
