// Copyright © 2022 Brian Drelling. All rights reserved.

import ArgumentParser
import Foundation

public struct MainCommand: ParsableCommand {
    public static let commandName = "kipple"
    
    public static let configuration: CommandConfiguration = .init(
        commandName: Self.commandName,
        abstract: "A set of core utilities for use with Kipple projects.",
        subcommands: [
            FormatCommand.self,
            InstallCommand.self,
            SetupCommand.self,
            UninstallCommand.self,
        ]
    )

    public init() {}
}
