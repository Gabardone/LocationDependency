// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LocationDependency",
    platforms: [
        // We're bound by SwiftUX minimum deployment version.
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
        .package(url: "https://github.com/Gabardone/GlobalDependencies", branch: "MacroSupport"),
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
