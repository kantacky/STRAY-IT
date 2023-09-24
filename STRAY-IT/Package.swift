// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "STRAY-IT",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(name: "STRAYIT", targets: ["STRAYIT"]),
        .library(name: "Adventure", targets: ["Adventure"]),
        .library(name: "Cheating", targets: ["Cheating"]),
        .library(name: "Composed", targets: ["Composed"]),
        .library(name: "Direction", targets: ["Direction"]),
        .library(name: "Search", targets: ["Search"]),
        .library(name: "Tutorial", targets: ["Tutorial"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", .upToNextMajor(from: "1.0.0")),
        .package(url: "https://github.com/pointfreeco/swift-dependencies.git", .upToNextMajor(from: "1.0.0")),
        .package(url: "https://github.com/apple/swift-format.git", .upToNextMajor(from: "509.0.0")),
    ],
    targets: [
        .target(
            name: "STRAYIT",
            dependencies: [
                "Composed",
                "LocationManager",
                "Search",
                "Tutorial",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ],
            plugins: []
        ),
        .target(
            name: "Adventure",
            dependencies: [
                "LocationManager",
                "SharedModel",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ],
            plugins: []
        ),
        .target(
            name: "Cheating",
            dependencies: [
                "LocationManager",
                "SharedModel",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ],
            plugins: []
        ),
        .target(
            name: "Composed",
            dependencies: [
                "Adventure",
                "Cheating",
                "Direction",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ],
            plugins: []
        ),
        .target(
            name: "Direction",
            dependencies: [
                "LocationManager",
                "SharedModel",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ],
            plugins: []
        ),
        .target(
            name: "LocationManager",
            dependencies: [
                .product(name: "Dependencies", package: "swift-dependencies"),
            ],
            plugins: []
        ),
        .target(
            name: "Search",
            dependencies: [
                "SharedModel",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ],
            plugins: []
        ),
        .target(
            name: "SharedModel",
            dependencies: [],
            plugins: []
        ),
        .target(
            name: "Tutorial",
            dependencies: [],
            plugins: []
        ),
        .testTarget(
            name: "STRAYITTests",
            dependencies: [
                "STRAYIT"
            ]
        ),
        .testTarget(
            name: "AdventureTests",
            dependencies: [
                "Adventure",
                "SharedModel"
            ]
        ),
        .testTarget(
            name: "CheatingTests",
            dependencies: [
                "Cheating",
                "SharedModel"
            ]
        ),
        .testTarget(
            name: "DirectionTests",
            dependencies: [
                "Direction",
                "SharedModel"
            ]
        ),
    ]
)
