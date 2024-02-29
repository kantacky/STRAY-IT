import Dependencies
import Foundation

extension UserDefaultsClient: DependencyKey {
    public static let liveValue: Self = {
        let defaults = { UserDefaults() }

        return UserDefaultsClient(
            boolForKey: { defaults().bool(forKey: $0) },
            dataForKey: { defaults().data(forKey: $0) },
            doubleForKey: { defaults().double(forKey: $0) },
            integerForKey: { defaults().integer(forKey: $0) },
            remove: { defaults().removeObject(forKey: $0) },
            setBool: { defaults().set($0, forKey: $1) },
            setData: { defaults().set($0, forKey: $1) },
            setDouble: { defaults().set($0, forKey: $1) },
            setInteger: { defaults().set($0, forKey: $1) }
        )
    }()
}

extension UserDefaultsClient: TestDependencyKey {
    public static let testValue = UserDefaultsClient(
        boolForKey: XCTUnimplemented("\(Self.self).boolForKey", placeholder: false),
        dataForKey: XCTUnimplemented("\(Self.self).dataForKey", placeholder: nil),
        doubleForKey: XCTUnimplemented("\(Self.self).doubleForKey", placeholder: 0),
        integerForKey: XCTUnimplemented("\(Self.self).integerForKey", placeholder: 0),
        remove: XCTUnimplemented("\(Self.self).remove"),
        setBool: XCTUnimplemented("\(Self.self).setBool"),
        setData: XCTUnimplemented("\(Self.self).setData"),
        setDouble: XCTUnimplemented("\(Self.self).setDouble"),
        setInteger: XCTUnimplemented("\(Self.self).setInteger")
    )
}
