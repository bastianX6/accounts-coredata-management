// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

private var targets: [Target] = [
    .target(
        name: "AccountsCoreDataManagement",
        dependencies: [
            "DataManagement",
            "CombineCoreData",
            .product(name: "Logging", package: "swift-log"),
        ]),
]

#if os(iOS)
    targets.append(
        .testTarget(
            name: "AccountsCoreDataManagementTests",
            dependencies: ["AccountsCoreDataManagement"])
    )
#endif

let package = Package(
    name: "AccountsCoreDataManagement",
    platforms: [
        .iOS(.v13),
        .tvOS(.v13),
        .macOS(.v10_15),
        .watchOS(.v6),
    ],
    products: [
        .library(
            name: "AccountsCoreDataManagement",
            targets: ["AccountsCoreDataManagement"]),
    ],
    dependencies: [
        .package(name: "DataManagement", url: "https://github.com/bastianX6/accounts-data-management.git", from: "1.0.1"),
        .package(url: "https://github.com/Alexander-Ignition/CombineCoreData", from: "0.0.3"),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.0.0"),
    ],
    targets: targets
)
