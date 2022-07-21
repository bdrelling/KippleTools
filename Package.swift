// swift-tools-version:5.6

import PackageDescription

let package = Package(
    name: "KipplePluginSupport",
    products: [
        .executable(name: "kipple-file-provider", targets: ["FileProvider"]),
    ],
    dependencies: [
        .package(url: "https://github.com/nicklockwood/SwiftFormat", from: "0.49.13"),
    ],
    targets: [
        // Product Targets
        .target(
            name: "PluginCore",
            dependencies: [],
            resources: [
                .process("Resources"),
            ]
        ),
        // Executable Targets
        .executableTarget(
            name: "FileProvider",
            dependencies: [
                .target(name: "PluginCore"),
            ]
        ),
        // Test Targets
        .testTarget(
            name: "PluginCoreTests",
            dependencies: [
                .target(name: "PluginCore"),
            ]
        ),
    ]
)
