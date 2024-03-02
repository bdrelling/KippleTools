import KippleToolsCore

final class SwiftBuilder {
    // MARK: Shared Instance

    static let shared = SwiftBuilder()
    
    // MARK: Properties
    
    private let sh: Shell = .bash

    // MARK: Initializers

    private init() {}

    // MARK: Methods

    func build(
        subcommand: ToolSubcommand,
        platforms: [Platform],
        versions: [SwiftVersion],
        isQuiet: Bool = false,
        isVerbose: Bool = false,
        logger: VerboseLogging
    ) throws -> String {
        let version = SwiftVersion.current
        
        print(version)
        
//        print(version)
        
        
        return ""
    }
    
    func buildAndExecute(
        subcommand: ToolSubcommand,
        platforms: [Platform],
        versions: [SwiftVersion],
        isQuiet: Bool = false,
        isVerbose: Bool = false,
        logger: VerboseLogging
    ) throws {
        let _ = try self.build(
            subcommand: subcommand,
            platforms: platforms,
            versions: versions,
            logger: logger
        )
    }
}

// MARK: - Supporting Types

enum Tool: String {
    case swift
    case xcodebuild
}

enum ToolSubcommand: String {
    case build
    case test
}
