// Copyright © 2023 Brian Drelling. All rights reserved.

import ArgumentParser
import Foundation
import KippleToolsCore

// swiftformat:options --varattributes prev-line
struct InstallCommand: ParsableCommand, VerboseLogging {
    static let configuration: CommandConfiguration = .init(
        commandName: "install",
        abstract: "Installs this executable into the user's local bin directory."
    )

    @Flag(name: .customLong("verbose"), help: "Whether or not to print debugging information.")
    var isVerbose: Bool = false

    @Option(help: "The build configuration to use.")
    private var configuration: BuildConfiguration = .release

    init() {}

    mutating func run() throws {
        // Define our user's local bin directory.
        let localBinDirectory = "~/.local/bin"

        // Define our command name.
        let commandName = MainCommand.commandName

        // Define our build configuration.
        let configuration = self.configuration.rawValue

        self.log("Building \(commandName)...")

        // Create our command, which does the following:
        // 1. Builds the tool.
        let buildCommand = "swift build -c \(configuration)"

        self.log("-- Command -------------------------------------------------")
        self.log(buildCommand)
        self.log("------------------------------------------------------------")

        // Run our command and get output.
        let buildOutput = try ConfiguredProcess.bash(command: buildCommand).run()
        self.log(buildOutput)

        // Get the path to the executable.
        let executablePath = "./.build/\(configuration)/\(commandName)"

        // Ensure the executable exists before we proceed to the copying step.
        let isBuilt = FileManager.default.fileExists(atPath: executablePath)

        if isBuilt {
            // Create our command, which does the following:
            // 1. Ensures our user's local bin directory exists.
            // 2. Copies the built binary to the bin directory.
            let copyCommand = """
            mkdir -p \(localBinDirectory)
            cp -f \(executablePath) \(localBinDirectory)/\(commandName)
            """

            self.log("-- Command -------------------------------------------------")
            self.log(copyCommand)
            self.log("------------------------------------------------------------")

            // Run our command and get output.
            let copyOutput = try ConfiguredProcess.bash(command: copyCommand).run()
            self.log(copyOutput)

            self.log("\(commandName) successfully installed to '\(localBinDirectory)'.", ignoresVerbose: true)
            self.log("To run the command, ensure '\(localBinDirectory)' exists in your PATH.", ignoresVerbose: true)
        } else {
            self.log("\(commandName) could not be installed. Executable not found at '\(executablePath)'.", ignoresVerbose: true)
        }
    }
}

// MARK: - Supporting Types

private enum BuildConfiguration: String, ExpressibleByArgument {
    case debug
    case release
}
