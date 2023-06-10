// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LocationDependency",
    platforms: [
        // We require Combine for the implementation so that limits what we support.
        .iOS(.v11),
        .macCatalyst(.v13),
        .macOS(.v11),
        .tvOS(.v11),
        .watchOS(.v4)
    ],
    products: [
        .library(
            name: "LocationDependency",
            targets: ["LocationDependency"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/Gabardone/GlobalDependencies", from: "2.0.0"),
        .package(url: "https://github.com/Gabardone/SwiftUX", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "LocationDependency",
            dependencies: ["GlobalDependencies", "SwiftUX"]
        ),
        .testTarget(
            name: "LocationDependencyTests",
            dependencies: ["GlobalDependencies", "LocationDependency", "SwiftUX"]
        )
    ]
)
