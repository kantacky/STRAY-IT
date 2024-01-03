import Dependencies

extension UserDefaultsClient: TestDependencyKey {
    public static let testValue: Self = .init(
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

    public static let previewValue = Self.testValue
}
