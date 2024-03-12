// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SYKit",
    platforms: [
        .iOS(.v12),
        .tvOS(.v12)
    ],
    products: [
        .library(name: "SYKit", targets: ["SYKit", "SYKitC"]),
    ],
    targets: [
        .target(name: "SYKit"),
        .target(name: "SYKitC", swiftSettings: [.interoperabilityMode(.C)]),
        .testTarget(name: "SYKitTests", dependencies: ["SYKit", "SYKitC"]),
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
