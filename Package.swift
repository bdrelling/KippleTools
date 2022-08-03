// swift-tools-version:5.6

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
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.1.3"),
        .package(url: "https://github.com/nicklockwood/SwiftFormat", from: "0.49.13"),
    ],
    targets: [
        // Executable Targets
        .executableTarget(
            name: "kipple",
            dependencies: [
                .target(name: "KippleFormat"),
            ]
        ),
        // Product Targets
        .target(
            name: "KippleFormat",
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
            ],
            resources: [
                .process("Resources"),
            ]
        ),
        // Test Targets
        .testTarget(
            name: "KippleToolsCoreTests",
            dependencies: [
                .target(name: "KippleToolsCore"),
            ]
        ),
    ]
)
