// swift-tools-version:5.6

import PackageDescription

let package = Package(
    name: "KippleTools",
    platforms: [
        .macOS(.v10_15),
    ],
    products: [
        .executable(name: "kipple-format", targets: ["KippleFormat"]),
        .executable(name: "kipple-file-provider", targets: ["KippleFileProvider"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.1.3"),
        .package(url: "https://github.com/nicklockwood/SwiftFormat", from: "0.49.13"),
    ],
    targets: [
        // Product Targets
        .target(
            name: "KippleToolsCore",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ],
            resources: [
                .process("Resources"),
            ]
        ),
        // Executable Targets
        .executableTarget(
            name: "KippleFormat",
            dependencies: [
                .target(name: "KippleToolsCore"),
                .product(name: "SwiftFormat", package: "SwiftFormat"),
            ],
            resources: [
                .process("Resources"),
            ]
        ),
        .executableTarget(
            name: "KippleFileProvider",
            dependencies: [
                .target(name: "KippleToolsCore"),
            ]
        ),
        // Test Targets
//        .testTarget(
//            name: "PluginCoreTests",
//            dependencies: [
//                .target(name: "PluginCore"),
//            ]
//        ),
    ]
)
