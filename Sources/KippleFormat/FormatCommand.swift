// Copyright © 2022 Brian Drelling. All rights reserved.

import ArgumentParser
import Foundation

// swiftformat:options --varattributes prev-line
public struct FormatCommand: ParsableCommand {
    public static let configuration: CommandConfiguration = .init(
        commandName: "format",
        abstract: "Formatters Swift files."
    )

    @Option(name: .customLong("config"), help: "The SwiftFormat configuration file path or template to use. (default: \"default\")")
    private var configurationFile: String?

    @Option(name: .long, help: "The Swift version to format.")
    private var swiftVersion: String?

    @Option(name: .long, help: "The list of targets. (default: [\".\"]")
    private var targets: [String] = ["."]

    @Flag(name: .customLong("staged-only"), help: "Whether or not to format staged files only.")
    private var shouldFormatStagedFilesOnly: Bool = false

    @Flag(name: .customLong("skip-cache"), help: "Whether or not to skip SwiftFormat's caching step.")
    private var shouldSkipCache: Bool = false

    @Flag(name: .customLong("debug"), help: "Whether or not to print debugging information.")
    private var isDebugging: Bool = false

    @Flag(name: .customLong("dryrun"), help: "Whether or not to skip the formatting step.")
    private var isDryRun: Bool = false

    @Flag(name: .customLong("quiet"), help: "Whether or not to quiet the SwiftFormat output.")
    private var isQuiet: Bool = false

    public init() {}

    public mutating func run() throws {
        try FileFormatter.format(
            configurationFile: self.configurationFile,
            swiftVersion: self.swiftVersion,
            targets: self.targets,
            shouldFormatStagedFilesOnly: self.shouldFormatStagedFilesOnly,
            shouldSkipCache: self.shouldSkipCache,
            isDebugging: self.isDebugging,
            isDryRun: self.isDryRun,
            isQuiet: self.isQuiet
        )
    }
}
