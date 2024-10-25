// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DcuiSchema",
    products: [
        .library(
            name: "DcuiSchema",
            targets: ["DcuiSchema"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "DcuiSchema",
            dependencies: []),
        .testTarget(
            name: "DcuiSchemaTests",
            dependencies: ["DcuiSchema"]),
    ]
)
