// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "STRAY-IT",
    defaultLocalization: "en",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "STRAYIT", targets: ["STRAYIT"]),
        .library(name: "Adventure", targets: ["Adventure"]),
        .library(name: "Assets", targets: ["Assets"]),
        .library(name: "Cheating", targets: ["Cheating"]),
        .library(name: "Direction", targets: ["Direction"]),
        .library(name: "Models", targets: ["Models"]),
        .library(name: "Navigation", targets: ["Navigation"]),
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
                "LocationManager",
                "Navigation",
                "Search",
                "Tutorial",
                .composableArchitecture,
            ]
        ),
        .target(
            name: "Adventure",
            dependencies: [
                "Assets",
                "LocationManager",
                "Models",
                .composableArchitecture,
            ]
        ),
        .target(name: "Assets"),
        .target(
            name: "Cheating",
            dependencies: [
                "Assets",
                "LocationManager",
                "Models",
                .composableArchitecture,
            ]
        ),
        .target(
            name: "Direction",
            dependencies: [
                "Assets",
                "LocationManager",
                "Models",
                .composableArchitecture,
            ]
        ),
        .target(
            name: "LocationManager",
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
                "Models"
            ]
        ),
        .testTarget(
            name: "CheatingTests",
            dependencies: [
                "Cheating",
                "Models"
            ]
        ),
        .testTarget(
            name: "DirectionTests",
            dependencies: [
                "Direction",
                "Models"
            ]
        ),
    ]
)

private extension Target.Dependency {
    static let composableArchitecture: Self = .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
    static let dependencies: Self = .product(name: "Dependencies", package: "swift-dependencies")
}
