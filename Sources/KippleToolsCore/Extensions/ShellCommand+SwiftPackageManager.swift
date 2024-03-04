// Copyright © 2024 Brian Drelling. All rights reserved.

public extension ShellCommand {
    /// Enum defining available package types when using the Swift Package Manager
    enum SwiftPackageType: String {
        case library
        case executable
    }

    /// Enum defining available build configurations when using the Swift Package Manager
    enum SwiftBuildConfiguration: String {
        case debug
        case release
    }

    /// Create a Swift package with a given type (see SwiftPackageType for options)
    static func createSwiftPackage(withType type: SwiftPackageType = .library) -> Self {
        .init("swift package init --type \(type.rawValue)")
    }

    /// Update all Swift package dependencies
    static func updateSwiftPackages() -> Self {
        .init("swift package update")
    }

    /// Generate an Xcode project for a Swift package
    static func generateSwiftPackageXcodeProject() -> Self {
        .init("swift package generate-xcodeproj")
    }

    /// Build a Swift package using a given configuration (see SwiftBuildConfiguration for options)
    static func buildSwiftPackage(withConfiguration configuration: SwiftBuildConfiguration = .debug) -> Self {
        .init("swift build -c \(configuration.rawValue)")
    }

    /// Test a Swift package using a given configuration (see SwiftBuildConfiguration for options)
    static func testSwiftPackage(withConfiguration configuration: SwiftBuildConfiguration = .debug) -> Self {
        .init("swift test -c \(configuration.rawValue)")
    }
}
