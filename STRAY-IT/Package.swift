// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "STRAY-IT",
    defaultLocalization: "en",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "STRAYIT", targets: ["STRAYIT"]),
        .library(name: "Adventure", targets: ["Adventure"]),
        .library(name: "Cheating", targets: ["Cheating"]),
        .library(name: "Composed", targets: ["Composed"]),
        .library(name: "Direction", targets: ["Direction"]),
        .library(name: "Resource", targets: ["Resource"]),
        .library(name: "Search", targets: ["Search"]),
        .library(name: "Tutorial", targets: ["Tutorial"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", .upToNextMajor(from: "1.0.0")),
        .package(url: "https://github.com/pointfreeco/swift-dependencies.git", .upToNextMajor(from: "1.0.0")),
        .package(url: "https://github.com/SwiftGen/SwiftGenPlugin.git", .upToNextMajor(from: "6.6.0")),
        .package(url: "https://github.com/realm/SwiftLint.git", .upToNextMajor(from: "0.52.0")),
    ],
    targets: [
        .target(
            name: "STRAYIT",
            dependencies: [
                "Composed",
                "LocationManager",
                "Resource",
                "Search",
                "Tutorial",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ],
            plugins: [.plugin(name: "SwiftLintPlugin", package: "SwiftLint")]
        ),
        .testTarget(
            name: "STRAYITTests",
            dependencies: ["STRAYIT"],
            plugins: [.plugin(name: "SwiftLintPlugin", package: "SwiftLint")]
        ),
        .target(
            name: "Adventure",
            dependencies: [
                "LocationManager",
                "Resource",
                "SharedModel",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ],
            plugins: [.plugin(name: "SwiftLintPlugin", package: "SwiftLint")]
        ),
        .target(
            name: "Cheating",
            dependencies: [
                "LocationManager",
                "Resource",
                "SharedModel",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ],
            plugins: [.plugin(name: "SwiftLintPlugin", package: "SwiftLint")]
        ),
        .target(
            name: "Composed",
            dependencies: [
                "Adventure",
                "Cheating",
                "Direction",
                "Resource",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "Direction",
            dependencies: [
                "LocationManager",
                "Resource",
                "SharedModel",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ],
            plugins: [.plugin(name: "SwiftLintPlugin", package: "SwiftLint")]
        ),
        .target(
            name: "LocationManager",
            dependencies: [
                .product(name: "Dependencies", package: "swift-dependencies"),
            ],
            plugins: [.plugin(name: "SwiftLintPlugin", package: "SwiftLint")]
        ),
        .target(
            name: "Resource",
            resources: [.process("Resource")],
            plugins: [.plugin(name: "SwiftGenPlugin", package: "SwiftGenPlugin")]
        ),
        .target(
            name: "Search",
            dependencies: [
                "LocationManager",
                "Resource",
                "SharedModel",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ],
            plugins: [.plugin(name: "SwiftLintPlugin", package: "SwiftLint")]
        ),
        .target(
            name: "SharedModel",
            dependencies: ["Resource"],
            plugins: [.plugin(name: "SwiftLintPlugin", package: "SwiftLint")]
        ),
        .target(
            name: "Tutorial",
            dependencies: ["Resource"],
            plugins: [.plugin(name: "SwiftLintPlugin", package: "SwiftLint")]
        )
    ]
)
