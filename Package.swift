// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AccountsCoreDataManagement",
    platforms: [
        .iOS(.v14),
        .tvOS(.v14),
        .macOS(.v11),
        .watchOS(.v7),
    ],
    products: [
        .library(
            name: "AccountsCoreDataManagement",
            targets: ["AccountsCoreDataManagement"]),
    ],
    dependencies: [
        .package(name: "DataManagement", url: "https://github.com/bastianX6/accounts-data-management.git", from: "1.0.2"),
        .package(url: "https://github.com/Alexander-Ignition/CombineCoreData", from: "0.0.3"),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "AccountsCoreDataManagement",
            dependencies: [
                "DataManagement",
                "CombineCoreData",
                .product(name: "Logging", package: "swift-log"),
            ]),
        .testTarget(
            name: "AccountsCoreDataManagementTests",
            dependencies: [
                "AccountsCoreDataManagement"
            ])
    ]
)
