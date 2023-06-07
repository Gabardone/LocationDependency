// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LocationDependency",
    platforms: [
        // We require Combine for the implementation so that limits what we support.
        .iOS(.v14),
        .macCatalyst(.v14),
        .macOS(.v11),
        .tvOS(.v14),
        .watchOS(.v7)
    ],
    products: [
        .library(
            name: "LocationDependency",
            targets: ["LocationDependency"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/Gabardone/GlobalDependencies", from: "2.0.0"),
        .package(url: "https://github.com/Gabardone/SwiftUX", from: "0.0.2-alpha")
    ],
    targets: [
        .target(
            name: "LocationDependency",
            dependencies: ["MiniDePin", "SwiftUX"]
        ),
        .testTarget(
            name: "LocationDependencyTests",
            dependencies: ["MiniDePin", "LocationDependency", "SwiftUX"]
        )
    ]
)
