// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "KippleTools",
    platforms: [
        .macOS(.v13),
    ],
    products: [
        .executable(name: "kipple", targets: ["kipple"]),
        .library(name: "KippleToolsCore", targets: ["KippleToolsCore"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.3.0"),
        .package(url: "https://github.com/nicklockwood/SwiftFormat", from: "0.53.10"),
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
