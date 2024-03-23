// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "STRAYITPackage",
    defaultLocalization: "en",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "STRAYITPackage", targets: ["STRAYITPackage"]),
        .library(name: "Cheating", targets: ["Cheating"]),
        .library(name: "Core", targets: ["Core"]),
        .library(name: "DebugUtils", targets: ["DebugUtils"]),
        .library(name: "Direction", targets: ["Direction"]),
        .library(name: "Launch", targets: ["Launch"]),
        .library(name: "STRAYITNavigation", targets: ["STRAYITNavigation"]),
        .library(name: "Search", targets: ["Search"]),
        .library(name: "Tutorial", targets: ["Tutorial"]),
    ],
    dependencies: [
        .package(url: "https://github.com/firebase/firebase-ios-sdk", .upToNextMajor(from: "10.0.0")),
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", .upToNextMajor(from: "1.0.0")),
        .package(url: "https://github.com/pointfreeco/swift-dependencies", .upToNextMajor(from: "1.0.0")),
        .package(url: "https://github.com/realm/SwiftLint", .upToNextMajor(from: "0.54.0")),
    ],
    targets: [
        .target(
            name: "Cheating",
            dependencies: [
                .entity,
                .locationClient,
                .strayitResource,
                .composableArchitecture,
            ],
            plugins: [
                .swiftLint,
            ]
        ),
        .testTarget(
            name: "CheatingTests",
            dependencies: [
                .cheating,
                .entity,
            ],
            plugins: [
                .swiftLint,
            ]
        ),
        .target(
            name: "Core",
            dependencies: [
                .composableArchitecture,
                .entity,
                .launch,
                .locationClient,
                .search,
                .strayitNavigation,
                .tutorial,
                .userDefaultsClient,
            ],
            plugins: [
                .swiftLint,
            ]
        ),
        .target(
            name: "DebugUtils",
            dependencies: [
                .composableArchitecture,
            ],
            plugins: [
                .swiftLint,
            ]
        ),
        .target(
            name: "Direction",
            dependencies: [
                .composableArchitecture,
                .entity,
                .locationClient,
                .strayitResource,
            ],
            plugins: [
                .swiftLint,
            ]
        ),
        .testTarget(
            name: "DirectionTests",
            dependencies: [
                .direction,
                .entity,
            ],
            plugins: [
                .swiftLint,
            ]
        ),
        .target(
            name: "Launch",
            dependencies: [
                .strayitResource,
                .composableArchitecture,
            ],
            plugins: [
                .swiftLint,
            ]
        ),
        .target(
            name: "LocationClient",
            dependencies: [
                .dependencies,
            ],
            plugins: [
                .swiftLint,
            ]
        ),
        .target(
            name: "Search",
            dependencies: [
                .composableArchitecture,
                .entity,
            ],
            plugins: [
                .swiftLint,
            ]
        ),
        .target(
            name: "STRAYITComponent",
            dependencies: [
                .strayitResource,
            ]
        ),
        .target(
            name: "STRAYITEntity",
            dependencies: [
                .strayitResource,
            ],
            plugins: [
                .swiftLint,
            ]
        ),
        .target(
            name: "STRAYITNavigation",
            dependencies: [
                .cheating,
                .composableArchitecture,
                .direction,
                .strayitComponent,
            ],
            plugins: [
                .swiftLint,
            ]
        ),
        .target(
            name: "STRAYITPackage",
            dependencies: [
                .composableArchitecture,
                .core,
                .debugUtils,
                .firebaseAnalytics,
                .firebaseAuth,
                .firebaseMessaging,
            ],
            resources: [
                .process("Resources"),
            ],
            plugins: [
                .swiftLint,
            ]
        ),
        .testTarget(
            name: "STRAYITPackageTests",
            dependencies: [
                .strayitPackage,
            ],
            plugins: [
                .swiftLint,
            ]
        ),
        .target(
            name: "STRAYITResource",
            dependencies: [],
            plugins: [
                .swiftLint,
            ]
        ),
        .target(
            name: "Tutorial",
            dependencies: [
                .strayitComponent,
                .strayitNavigation,
            ],
            plugins: [
                .swiftLint,
            ]
        ),
        .target(
            name: "UserDefaultsClient",
            dependencies: [
                .dependencies,
            ],
            plugins: [
                .swiftLint,
            ]
        ),
    ]
)

private extension Target.Dependency {
    static let cheating: Self = "Cheating"
    static let core: Self = "Core"
    static let debugUtils: Self = "DebugUtils"
    static let direction: Self = "Direction"
    static let entity: Self = "STRAYITEntity"
    static let launch: Self = "Launch"
    static let locationClient: Self = "LocationClient"
    static let search: Self = "Search"
    static let strayitComponent: Self = "STRAYITComponent"
    static let strayitNavigation: Self = "STRAYITNavigation"
    static let strayitPackage: Self = "STRAYITPackage"
    static let strayitResource: Self = "STRAYITResource"
    static let tutorial: Self = "Tutorial"
    static let userDefaultsClient: Self = "UserDefaultsClient"

    static let composableArchitecture: Self = .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
    static let dependencies: Self = .product(name: "Dependencies", package: "swift-dependencies")
    static let firebaseAnalytics: Self = .product(name: "FirebaseAnalytics", package: "firebase-ios-sdk")
    static let firebaseAuth: Self = .product(name: "FirebaseAuth", package: "firebase-ios-sdk")
    static let firebaseMessaging: Self = .product(name: "FirebaseMessaging", package: "firebase-ios-sdk")
}

private extension Target.PluginUsage {
    static let swiftLint: Self = .plugin(name: "SwiftLintPlugin", package: "SwiftLint")
}
