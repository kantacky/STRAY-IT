// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "STRAY-IT",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "STRAYIT",
            targets: ["STRAYIT"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/composable-core-location", .upToNextMajor(from: "0.2.0")),
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", .upToNextMajor(from: "0.53.0")),
        .package(url: "https://github.com/SwiftGen/SwiftGenPlugin", .upToNextMajor(from: "6.6.0")),
        .package(url: "https://github.com/realm/SwiftLint", .upToNextMajor(from: "0.52.0")),
        .package(url: "https://github.com/kantacky/SwiftMKMap", .upToNextMajor(from: "0.1.0"))
    ],
    targets: [
        .target(
            name: "STRAYIT",
            dependencies: [
                "Adventure",
                "Cheating",
                "Dependency",
                "Direction",
                "Resource",
                "Search",
                "SharedLogic",
                "SharedModel",
                "Tutorial",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "ComposableCoreLocation", package: "composable-core-location"),
                .product(name: "SwiftMKMap", package: "SwiftMKMap")
            ],
            plugins: [
                .plugin(name: "SwiftGenPlugin", package: "SwiftGenPlugin"),
                .plugin(name: "SwiftLintPlugin", package: "SwiftLint")
            ]
        ),
        .testTarget(
            name: "STRAYITTests",
            dependencies: [
                "STRAYIT"
            ],
            plugins: [
                .plugin(name: "SwiftLintPlugin", package: "SwiftLint")
            ]
        ),
        .target(
            name: "Adventure",
            dependencies: [
                "Dependency",
                "Resource",
                "SharedLogic",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "ComposableCoreLocation", package: "composable-core-location"),
                .product(name: "SwiftMKMap", package: "SwiftMKMap")
            ],
            plugins: [
                .plugin(name: "SwiftLintPlugin", package: "SwiftLint")
            ]
        ),
        .target(
            name: "Cheating",
            dependencies: [
                "Dependency",
                "Resource",
                "SharedLogic",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "ComposableCoreLocation", package: "composable-core-location"),
                .product(name: "SwiftMKMap", package: "SwiftMKMap")
            ],
            plugins: [
                .plugin(name: "SwiftLintPlugin", package: "SwiftLint")
            ]
        ),
        .target(
            name: "Dependency",
            dependencies: [
                .product(name: "ComposableCoreLocation", package: "composable-core-location"),
                .product(name: "SwiftMKMap", package: "SwiftMKMap")
            ],
            plugins: [
                .plugin(name: "SwiftLintPlugin", package: "SwiftLint")
            ]
        ),
        .target(
            name: "Direction",
            dependencies: [
                "Dependency",
                "Resource",
                "SharedLogic",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "ComposableCoreLocation", package: "composable-core-location"),
                .product(name: "SwiftMKMap", package: "SwiftMKMap")
            ],
            plugins: [
                .plugin(name: "SwiftLintPlugin", package: "SwiftLint")
            ]
        ),
        .target(
            name: "Resource",
            dependencies: []
        ),
        .target(
            name: "Search",
            dependencies: [
                "Dependency",
                "Resource",
                "SharedLogic",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "ComposableCoreLocation", package: "composable-core-location"),
                .product(name: "SwiftMKMap", package: "SwiftMKMap")
            ],
            plugins: [
                .plugin(name: "SwiftLintPlugin", package: "SwiftLint")
            ]
        ),
        .target(
            name: "SharedLogic",
            dependencies: [
                .product(name: "SwiftMKMap", package: "SwiftMKMap")
            ],
            plugins: [
                .plugin(name: "SwiftLintPlugin", package: "SwiftLint")
            ]
        ),
        .target(
            name: "SharedModel",
            dependencies: [
                "Resource"
            ]
        ),
        .target(
            name: "Tutorial",
            dependencies: [
                "Resource"
            ],
            plugins: [
                .plugin(name: "SwiftLintPlugin", package: "SwiftLint")
            ]
        )
    ]
)
