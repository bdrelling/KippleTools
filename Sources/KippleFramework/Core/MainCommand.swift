// Copyright © 2024 Brian Drelling. All rights reserved.

// If we're not running on macOS or Linux, throw an error so we know we're building for the wrong platform.
#if !(os(macOS) || os(Linux))
#error("KippleTools is only compatible with macOS and Linux.")
#endif

import ArgumentParser
import Foundation

public struct MainCommand: ParsableCommand {
    public static let commandName = "kipple"

    public static let configuration: CommandConfiguration = .init(
        commandName: Self.commandName,
        abstract: "A set of core utilities for use with Swift projects.",
        subcommands: [
            SetupCommand.self,
            InstallCommand.self,
            UninstallCommand.self,
            FormatCommand.self,
            // BuildCommand.self,
            // TestCommand.self,
        ]
    )

    public init() {}
}
