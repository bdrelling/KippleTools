// Copyright © 2022 Brian Drelling. All rights reserved.

import ArgumentParser
import Foundation
import KippleFormat

@main
struct KippleCommand: ParsableCommand {
    static let configuration: CommandConfiguration = .init(
        commandName: "kipple",
        abstract: "A set of core utilities for use with Kipple projects.",
        subcommands: [
            FormatCommand.self,
        ]
    )
}
