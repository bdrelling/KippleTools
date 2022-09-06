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

    public init() {}

    public mutating func run() throws {
        // Create our command, which does the following:
        // 1. Builds the tool in the "release" configuration.
        // 2. Ensures our $HOME/.local/bin directory exists.
        // 3. Copies the built binary to the bin directory.
        let command = """
        swift build -c release
        mkdir ~/.local/bin
        cp -f ./.build/release/kipple ~/.local/bin/kipple
        """

        // Run our command and get output.
        let output = try ConfiguredProcess.bash(command: command).run()

        // Log the output.
        self.log(output)
    }

    private func log(_ message: String) {
        guard self.isVerbose else {
            return
        }

        print(message)
    }
}
