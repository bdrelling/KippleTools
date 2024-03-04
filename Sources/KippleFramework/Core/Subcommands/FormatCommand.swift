// Copyright © 2024 Brian Drelling. All rights reserved.

import ArgumentParser
import Foundation
import KippleToolsCore

// swiftformat:options --varattributes prev-line
struct FormatCommand: ParsableCommand, VerboseLogging {
    // MARK: Configuration

    static let configuration: CommandConfiguration = .init(
        commandName: "format",
        abstract: "Formats Swift files."
    )

    // MARK: Arguments

    @Option(name: .customLong("config"), help: "The SwiftFormat configuration file path or template to use. (default: \".swiftformat\")")
    private var configurationFile: String = ".swiftformat"

    @Option(name: .long, help: "The Swift version to format.")
    private var swiftVersion: String?

    @Option(name: .long, help: "The list of targets. (default: [\".\"])")
    private var targets: [String] = ["."]

    @Flag(name: .customLong("staged-only"), help: "Whether or not to format staged files only.")
    private var shouldFormatStagedFilesOnly: Bool = false

    @Flag(name: .customLong("skip-cache"), help: "Whether or not to skip SwiftFormat's caching step.")
    private var shouldSkipCache: Bool = false

    @Flag(name: .customLong("dryrun"), help: "Whether or not to skip the formatting step.")
    private var isDryRun: Bool = false

    @Flag(name: .customLong("quiet"), help: "Whether or not to quiet the SwiftFormat output.")
    private var isQuiet: Bool = false

    @Flag(name: .customLong("verbose"), help: "Whether or not to print debugging information and verbose SwiftFormat output.")
    var isVerbose: Bool = false

    // MARK: Initializers

    init() {}

    // MARK: Methods

    mutating func run() throws {
        try FileFormatter.shared.format(
            configurationFile: self.configurationFile,
            swiftVersion: self.swiftVersion,
            targets: self.targets,
            shouldFormatStagedFilesOnly: self.shouldFormatStagedFilesOnly,
            shouldSkipCache: self.shouldSkipCache,
            isDryRun: self.isDryRun,
            isQuiet: self.isQuiet,
            isVerbose: self.isVerbose,
            logger: self
        )
    }
}
