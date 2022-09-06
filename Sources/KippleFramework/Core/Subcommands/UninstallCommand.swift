// Copyright © 2022 Brian Drelling. All rights reserved.

import ArgumentParser
import Foundation
import KippleToolsCore

// swiftformat:options --varattributes prev-line
public struct UninstallCommand: ParsableCommand {
    public static let configuration: CommandConfiguration = .init(
        commandName: "uninstall",
        abstract: "Uninstalls the kipple tool globally."
    )

    @Flag(name: .customLong("verbose"), help: "Whether or not to print debugging information.")
    private var isVerbose: Bool = false

    public init() {}

    public mutating func run() throws {
        // Define our user's local bin directory.
        let localBinDirectory = "~/.local/bin"

        // Define our command name.
        let commandName = "kipple"

        // Create our command, which simply deletes the binary from the local bin directory.
        let command = "rm \(localBinDirectory)/\(commandName)"

        self.log("-- Command -------------------------------------------------")
        self.log(command)
        self.log("------------------------------------------------------------")

        // Run our command and get output.
        let output = try ConfiguredProcess.bash(command: command).run()

        self.log(output)

        self.log("kipple successfully uninstalled from '\(localBinDirectory)'.", ignoresVerbose: true)
    }

    private func log(_ message: String, ignoresVerbose: Bool = false) {
        guard ignoresVerbose || self.isVerbose else {
            return
        }

        print(message)
    }
}
