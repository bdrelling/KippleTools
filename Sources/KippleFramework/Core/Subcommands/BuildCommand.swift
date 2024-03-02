// Copyright © 2024 Brian Drelling. All rights reserved.

import ArgumentParser
import Foundation
import KippleToolsCore

// swiftformat:options --varattributes prev-line
struct BuildCommand: ParsableCommand, VerboseLogging {
    // MARK: Configuration
    
    static let configuration: CommandConfiguration = .init(
        commandName: "build",
        abstract: "Builds Swift packages and Xcode projects."
    )
    
    // MARK: Arguments
    
    @Option(name: .long, help: "The list of platforms of build.")
    private var platforms: [Platform] = []

    @Option(name: .long, help: "The list of Swift versions to build.")
    private var swiftVersions: [SwiftVersion] = []
    
    @Flag(name: .customLong("execute"), help: "Whether or not to execute the command. Must be explicitly provided.")
    private var isExecuting: Bool = false
    
    @Flag(name: .customLong("quiet"), help: "Whether or not to quiet all output.")
    private var isQuiet: Bool = false

    @Flag(name: .customLong("verbose"), help: "Whether or not to print debugging information.")
    var isVerbose: Bool = false
    
    // MARK: Initializers

    init() {}
    
    // MARK: Methods

    mutating func run() throws {
        try SwiftBuilder.shared.buildAndExecute(
            subcommand: .build,
            platforms: self.platforms,
            versions: self.swiftVersions,
            isQuiet: self.isQuiet,
            isVerbose: self.isVerbose,
            logger: self
        )
    }
}

