// Copyright © 2024 Brian Drelling. All rights reserved.

import ArgumentParser
import Foundation
import KippleToolsCore

// swiftformat:options --varattributes prev-line
struct UninstallCommand: ParsableCommand, VerboseLogging {
    // MARK: Configuration
    
    static let configuration: CommandConfiguration = .init(
        commandName: "uninstall",
        abstract: "Uninstalls this executable by removing it from the user's local bin directory."
    )
    
    // MARK: Arguments

    @Flag(name: .customLong("verbose"), help: "Whether or not to print debugging information.")
    var isVerbose: Bool = false
    
    // MARK: Initializers

    init() {}
    
    // MARK: Methods

    mutating func run() throws {
        // Define our user's local bin directory.
        let localBinDirectory = "~/.local/bin"

        // Define our command name.
        let commandName = MainCommand.commandName

        // Create our command, which simply deletes the binary from the local bin directory.
        let command = "rm \(localBinDirectory)/\(commandName)"

        self.log("-- Command -------------------------------------------------")
        self.log(command)
        self.log("------------------------------------------------------------")

        // Run our command and get output.
        let output = try Shell.bash(command)

        self.log(output)

        self.log("\(commandName) successfully uninstalled from '\(localBinDirectory)'.", ignoresVerbose: true)
    }
}
