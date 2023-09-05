// swiftlint:disable missing_docs

import Dependencies
import Foundation

extension DependencyValues {
    public var userDefaults: UserDefaultsClient {
        get { self[UserDefaultsClient.self] }
        set { self[UserDefaultsClient.self] = newValue }
    }
}

/// UserDefaultsClient
public struct UserDefaultsClient {
    private var boolForKey: (String) -> Bool
    private var dataForKey: (String) -> Data?
    private var doubleForKey: (String) -> Double
    private var integerForKey: (String) -> Int
    private var remove: (String) async -> Void
    private var setBool: (Bool, String) async -> Void
    private var setData: (Data, String) async -> Void
    private var setDouble: (Double, String) async -> Void
    private var setInteger: (Int, String) async -> Void

    public init(
        boolForKey: @escaping (String) -> Bool,
        dataForKey: @escaping (String) -> Data?,
        doubleForKey: @escaping (String) -> Double,
        integerForKey: @escaping (String) -> Int,
        remove: @escaping (String) async -> Void,
        setBool: @escaping (Bool, String) async -> Void,
        setData: @escaping (Data, String) async -> Void,
        setDouble: @escaping (Double, String) async -> Void,
        setInteger: @escaping (Int, String) async -> Void
    ) {
        self.boolForKey = boolForKey
        self.dataForKey = dataForKey
        self.doubleForKey = doubleForKey
        self.integerForKey = integerForKey
        self.remove = remove
        self.setBool = setBool
        self.setData = setData
        self.setDouble = setDouble
        self.setInteger = setInteger
    }

    public func bool(forKey key: UserDefaultsKey<Bool>) -> Bool {
        boolForKey(key.name)
    }

    public func double(forKey key: UserDefaultsKey<Double>) -> Double {
        doubleForKey(key.name)
    }

    public func integer(forKey key: UserDefaultsKey<Int>) -> Int {
        integerForKey(key.name)
    }

    public func customType<T: Codable>(forKey key: UserDefaultsKey<T>) throws -> T {
        guard let data = dataForKey(key.name) else {
            return key.defaultValue
        }
        let value: T = try JSONDecoder().decode(key.valueType, from: data)
        return value
    }

    public func set(_ value: Bool, forKey key: UserDefaultsKey<Bool>) async {
        await setBool(value, key.name)
    }

    public func set(_ value: Double, forKey key: UserDefaultsKey<Double>) async {
        await setDouble(value, key.name)
    }

    public func set(_ value: Int, forKey key: UserDefaultsKey<Int>) async {
        await setInteger(value, key.name)
    }

    public func set<T: Codable>(_ value: T, forKey key: UserDefaultsKey<T>) async throws {
        let data: Data = try JSONEncoder().encode(value)
        await setData(data, key.name)
    }
}

public struct UserDefaultsKey<T> {
    public var name: String
    public var defaultValue: T
    public var valueType: T.Type

    public init(
        name: String,
        defaultValue: T
    ) {
        self.name = name
        self.defaultValue = defaultValue
        self.valueType = T.self
    }

    public init(
        name: String,
        defaultValue: T = nil
    ) where T: OptionalType {
        self.name = name
        self.defaultValue = defaultValue
        self.valueType = T.self
    }
}

public enum UserDefaultsKeys {}

public protocol OptionalType: ExpressibleByNilLiteral {
    associatedtype WrappedType
}

extension Optional: OptionalType {
    public typealias WrappedType = Wrapped
}

// swiftlint:enable missing_docs
