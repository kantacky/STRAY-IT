// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "STRAY-IT",
    defaultLocalization: "en",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "STRAYIT", targets: ["STRAYIT"]),
        .library(name: "Adventure", targets: ["Adventure"]),
        .library(name: "Cheating", targets: ["Cheating"]),
        .library(name: "Core", targets: ["Core"]),
        .library(name: "DebugUtils", targets: ["DebugUtils"]),
        .library(name: "Direction", targets: ["Direction"]),
        .library(name: "Launch", targets: ["Launch"]),
        .library(name: "Navigation", targets: ["Navigation"]),
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
            name: "STRAYIT",
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
            name: "STRAYITTests",
            dependencies: [
                .strayIt,
            ],
            plugins: [
                .swiftLint,
            ]
        ),
        .target(
            name: "Adventure",
            dependencies: [
                .composableArchitecture,
                .entity,
                .locationClient,
                .resources,
            ],
            plugins: [
                .swiftLint,
            ]
        ),
        .testTarget(
            name: "AdventureTests",
            dependencies: [
                .adventure,
                .entity,
            ],
            plugins: [
                .swiftLint,
            ]
        ),
        .target(
            name: "Cheating",
            dependencies: [
                .entity,
                .locationClient,
                .resources,
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
                .navigation,
                .search,
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
                .resources,
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
            name: "Entity",
            dependencies: [],
            plugins: [
                .swiftLint,
            ]
        ),
        .target(
            name: "Launch",
            dependencies: [
                .resources,
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
            name: "Navigation",
            dependencies: [
                .adventure,
                .cheating,
                .composableArchitecture,
                .direction,
            ],
            plugins: [
                .swiftLint,
            ]
        ),
        .target(
            name: "Resources",
            dependencies: [],
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
            name: "Tutorial",
            dependencies: [
                .navigation,
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
    static let adventure: Self = "Adventure"
    static let cheating: Self = "Cheating"
    static let core: Self = "Core"
    static let debugUtils: Self = "DebugUtils"
    static let direction: Self = "Direction"
    static let entity: Self = "Entity"
    static let launch: Self = "Launch"
    static let locationClient: Self = "LocationClient"
    static let navigation: Self = "Navigation"
    static let resources: Self = "Resources"
    static let search: Self = "Search"
    static let strayIt: Self = "STRAYIT"
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
