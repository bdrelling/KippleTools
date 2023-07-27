// swift-tools-version: 5.5

import PackageDescription

let package = Package(
    name: "KippleTools",
    platforms: [
        .macOS(.v10_15),
    ],
    products: [
        .executable(name: "kipple", targets: ["kipple"]),
        .library(name: "KippleToolsCore", targets: ["KippleToolsCore"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.2.2"),
        .package(url: "https://github.com/nicklockwood/SwiftFormat", .upToNextMinor(from: "0.51.13")),
    ],
    targets: [
        // Executable Targets
        .executableTarget(
            name: "kipple",
            dependencies: [
                .target(name: "KippleFramework"),
            ]
        ),
        // Product Targets
        .target(
            name: "KippleFramework",
            dependencies: [
                .target(name: "KippleToolsCore"),
                .product(name: "SwiftFormat", package: "SwiftFormat"),
            ],
            resources: [
                .process("Resources"),
            ]
        ),
        .target(
            name: "KippleToolsCore",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]
        ),
        // Test Targets
        .testTarget(
            name: "KippleFrameworkTests",
            dependencies: [
                .target(name: "KippleFramework"),
            ]
        ),
        .testTarget(
            name: "KippleToolsCoreTests",
            dependencies: [
                .target(name: "KippleToolsCore"),
            ]
        ),
    ]
)
