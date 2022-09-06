// Copyright © 2022 Brian Drelling. All rights reserved.

import ArgumentParser
import Foundation
import KippleToolsCore

// swiftformat:options --varattributes prev-line
public struct InstallCommand: ParsableCommand {
    public static let configuration: CommandConfiguration = .init(
        commandName: "install",
        abstract: "Installs the kipple tool globally."
    )

    @Flag(name: .customLong("verbose"), help: "Whether or not to print debugging information.")
    private var isVerbose: Bool = false

    @Option(help: "The build configuration to use.")
    private var configuration: BuildConfiguration = .release

    public init() {}

    public mutating func run() throws {
        // Define our user's local bin directory.
        let localBinDirectory = "~/.local/bin"

        // Define our command name.
        let commandName = "kipple"

        // Define our build configuration.
        let configuration = self.configuration.rawValue

        self.log("Building \(commandName)...")

        // Create our command, which does the following:
        // 1. Builds the tool.
        // 2. Ensures our user's local bin directory exists.
        // 3. Copies the built binary to the bin directory.
        let command = """
        swift build -c \(configuration)
        mkdir -p \(localBinDirectory)
        cp -f ./.build/\(configuration)/\(commandName) \(localBinDirectory)/\(commandName)
        """

        self.log("-- Command -------------------------------------------------")
        self.log(command)
        self.log("------------------------------------------------------------")

        // Run our command and get output.
        let output = try ConfiguredProcess.bash(command: command).run()

        self.log(output)

        self.log("kipple successfully installed to '\(localBinDirectory)'.", ignoreVerbose: true)
        self.log("To run the command, '\(localBinDirectory)' must exist in your PATH.")
    }

    private func log(_ message: String, ignoreVerbose: Bool = false) {
        guard ignoreVerbose || self.isVerbose else {
            return
        }

        print(message)
    }
}

// MARK: - Supporting Types

private enum BuildConfiguration: String, ExpressibleByArgument {
    case debug
    case release
}
