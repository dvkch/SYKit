// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SYKit",
    platforms: [
        .iOS(.v12),
        .macOS(.v10_13),
        .tvOS(.v12)
    ],
    products: [
        .library(name: "SYKit", targets: ["SYKit"]),
    ],
    targets: [
        .target(name: "SYKit"),
        .testTarget(name: "SYKitTests", dependencies: ["SYKit"]),
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
