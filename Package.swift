// swift-tools-version:5.6

import PackageDescription

let package = Package(
    name: "PluginSupport",
    products: [
        .executable(name: "kipple-file-fetcher", targets: ["FileFetcher"]),
    ],
    dependencies: [
//        .package(url: "https://github.com/swift-kipple/Plugins", from: "0.3.0")
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
            name: "FileFetcher",
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
