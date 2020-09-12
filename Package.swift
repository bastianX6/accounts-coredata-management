// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AccountsCoreDataManagement",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "AccountsCoreDataManagement",
            targets: ["AccountsCoreDataManagement"]),
    ],
    dependencies: [
        .package(name: "DataManagement", url: "../accounts-data-management", from: "1.0.0"),
        .package(url: "https://github.com/Alexander-Ignition/CombineCoreData", from: "0.0.3"),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "AccountsCoreDataManagement",
            dependencies: [
                "DataManagement",
                "CombineCoreData",
                .product(name: "Logging", package: "swift-log"),
            ]),
        .testTarget(
            name: "AccountsCoreDataManagementTests",
            dependencies: ["AccountsCoreDataManagement"]),
    ]
)
