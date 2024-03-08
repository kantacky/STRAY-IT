// swift-tools-version: 5.10

import PackageDescription

extension SwiftSetting {
    /// Forward-scan matching for trailing closures
    /// - Version: Swift 5.3
    /// - Since: SwiftPM 5.8
    /// - SeeAlso: [SE-0286: Forward-scan matching for trailing closures](https://github.com/apple/swift-evolution/blob/main/proposals/0286-forward-scan-trailing-closures.md)
    static let forwardTrailingClosures: Self = .enableUpcomingFeature("ForwardTrailingClosures")
    /// Introduce existential `any`
    /// - Version: Swift 5.6
    /// - Since: SwiftPM 5.8
    /// - SeeAlso: [SE-0335: Introduce existential `any`](https://github.com/apple/swift-evolution/blob/main/proposals/0335-existential-any.md)
    static let existentialAny: Self = .enableUpcomingFeature("ExistentialAny")
    /// Regex Literals
    /// - Version: Swift 5.7
    /// - Since: SwiftPM 5.8
    /// - SeeAlso: [SE-0354: Regex Literals](https://github.com/apple/swift-evolution/blob/main/proposals/0354-regex-literals.md)
    static let bareSlashRegexLiterals: Self = .enableUpcomingFeature("BareSlashRegexLiterals")
    /// Concise magic file names
    /// - Version: Swift 5.8
    /// - Since: SwiftPM 5.8
    /// - SeeAlso: [SE-0274: Concise magic file names](https://github.com/apple/swift-evolution/blob/main/proposals/0274-magic-file.md)
    static let conciseMagicFile: Self = .enableUpcomingFeature("ConciseMagicFile")
    /// Importing Forward Declared Objective-C Interfaces and Protocols
    /// - Version: Swift 5.9
    /// - Since: SwiftPM 5.9
    /// - SeeAlso: [SE-0384: Importing Forward Declared Objective-C Interfaces and Protocols](https://github.com/apple/swift-evolution/blob/main/proposals/0384-importing-forward-declared-objc-interfaces-and-protocols.md)
    static let importObjcForwardDeclarations: Self = .enableUpcomingFeature("ImportObjcForwardDeclarations")
    /// Remove Actor Isolation Inference caused by Property Wrappers
    /// - Version: Swift 5.9
    /// - Since: SwiftPM 5.9
    /// - SeeAlso: [SE-0401: Remove Actor Isolation Inference caused by Property Wrappers](https://github.com/apple/swift-evolution/blob/main/proposals/0401-remove-property-wrapper-isolation.md)
    static let disableOutwardActorInference: Self = .enableUpcomingFeature("DisableOutwardActorInference")
    /// Deprecate `@UIApplicationMain` and `@NSApplicationMain`
    /// - Version: Swift 5.10
    /// - Since: SwiftPM 5.10
    /// - SeeAlso: [SE-0383: Deprecate `@UIApplicationMain` and `@NSApplicationMain`](https://github.com/apple/swift-evolution/blob/main/proposals/0383-deprecate-uiapplicationmain-and-nsapplicationmain.md)
    static let deprecateApplicationMain: Self = .enableUpcomingFeature("DeprecateApplicationMain")
    /// Isolated default value expressions
    /// - Version: Swift 5.10
    /// - Since: SwiftPM 5.10
    /// - SeeAlso: [SE-0411: Isolated default value expressions](https://github.com/apple/swift-evolution/blob/main/proposals/0411-isolated-default-values.md)
    static let isolatedDefaultValues: Self = .enableUpcomingFeature("IsolatedDefaultValues")
    /// Strict concurrency for global variables
    /// - Version: Swift 5.10
    /// - Since: SwiftPM 5.10
    /// - SeeAlso: [SE-0412: Strict concurrency for global variables](https://github.com/apple/swift-evolution/blob/main/proposals/0412-strict-concurrency-for-global-variables.md)
    static let globalConcurrency: Self = .enableUpcomingFeature("GlobalConcurrency")
}

let package = Package(
    name: "STRAY-IT",
    defaultLocalization: "en",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "STRAYIT", targets: ["STRAYIT"]),
        .library(name: "Adventure", targets: ["Adventure"]),
        .library(name: "Cheating", targets: ["Cheating"]),
        .library(name: "Core", targets: ["Core"]),
        .library(name: "Direction", targets: ["Direction"]),
        .library(name: "Launch", targets: ["Launch"]),
        .library(name: "Navigation", targets: ["Navigation"]),
        .library(name: "Search", targets: ["Search"]),
        .library(name: "Tutorial", targets: ["Tutorial"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", .upToNextMajor(from: "1.0.0")),
        .package(url: "https://github.com/pointfreeco/swift-dependencies.git", .upToNextMajor(from: "1.0.0")),
//        .package(url: "https://github.com/realm/SwiftLint.git", .upToNextMajor(from: "0.1.0")),
    ],
    targets: [
        .target(
            name: "STRAYIT",
            dependencies: [
                "Core",
                .composableArchitecture,
            ]
        ),
        .testTarget(
            name: "STRAYITTests",
            dependencies: [
                "STRAYIT"
            ]
        ),
        .target(
            name: "Adventure",
            dependencies: [
                "LocationClient",
                "Models",
                "Resources",
                .composableArchitecture,
            ]
        ),
        .testTarget(
            name: "AdventureTests",
            dependencies: [
                "Adventure",
                "Models"
            ]
        ),
        .target(
            name: "Cheating",
            dependencies: [
                "LocationClient",
                "Models",
                "Resources",
                .composableArchitecture,
            ]
        ),
        .testTarget(
            name: "CheatingTests",
            dependencies: [
                "Cheating",
                "Models"
            ]
        ),
        .target(
            name: "Core",
            dependencies: [
                "Launch",
                "LocationClient",
                "Models",
                "Navigation",
                "Search",
                "Tutorial",
                "UserDefaultsClient",
                .composableArchitecture,
            ]
        ),
        .target(
            name: "Direction",
            dependencies: [
                "LocationClient",
                "Models",
                "Resources",
                .composableArchitecture,
            ]
        ),
        .testTarget(
            name: "DirectionTests",
            dependencies: [
                "Direction",
                "Models"
            ]
        ),
        .target(
            name: "Launch",
            dependencies: [
                "Resources",
                .composableArchitecture,
            ]
        ),
        .target(
            name: "LocationClient",
            dependencies: [
                .dependencies,
            ]
        ),
        .target(name: "Models"),
        .target(
            name: "Navigation",
            dependencies: [
                "Adventure",
                "Cheating",
                "Direction",
                .composableArchitecture,
            ]
        ),
        .target(name: "Resources"),
        .target(
            name: "Search",
            dependencies: [
                "Models",
                .composableArchitecture,
            ]
        ),
        .target(
            name: "Tutorial",
            dependencies: [
                "Navigation",
            ]
        ),
        .target(
            name: "UserDefaultsClient",
            dependencies: [
                .dependencies,
            ]
        ),
    ]
)

private extension Target.Dependency {
    static let composableArchitecture: Self = .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
    static let dependencies: Self = .product(name: "Dependencies", package: "swift-dependencies")
}

private extension Target.PluginUsage {
//    static let swiftLint: Self = .plugin(name: "SwiftLintPlugin", package: "SwiftLint")
}
