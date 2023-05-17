import Dependencies
import Foundation

extension UserDefaultsClient: TestDependencyKey {
    public static let testValue: Self = {
        var store: [String: Any] = [:]

        return Self(
            boolForKey: { store[$0] as? Bool ?? false },
            dataForKey: { store[$0] as? Data },
            doubleForKey: { store[$0] as? Double ?? 0.0 },
            integerForKey: { store[$0] as? Int ?? 0 },
            remove: { store[$0] = nil },
            setBool: { store[$1] = $0 },
            setData: { store[$1] = $0 },
            setDouble: { store[$1] = $0 },
            setInteger: { store[$1] = $0 }
        )
    }()
}
