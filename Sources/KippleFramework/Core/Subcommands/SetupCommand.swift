// Copyright © 2022 Brian Drelling. All rights reserved.

import ArgumentParser
import Foundation
import KippleToolsCore

// swiftformat:options --varattributes prev-line
struct SetupCommand: ParsableCommand, VerboseLogging {
    static let configuration: CommandConfiguration = .init(
        commandName: "setup",
        abstract: "Sets up a project by installing git hooks and performing other setup actions."
    )

    @Flag(name: .customLong("verbose"), help: "Whether or not to print debugging information.")
    var isVerbose: Bool = false

    init() {}

    mutating func run() throws {
        // Install all available git hooks.
        try self.installGitHooks()
    }

    private func installGitHooks() throws {
        self.log("Preparing to install git hooks...")

        // Fetch each file in the bundle that matches the name of an available git-hook.
        let resourceURLs = Self.availableGitHooks.compactMap {
            Bundle.module.url(forResource: $0, withExtension: nil)
        }

        // Get the number of git hooks we're planning to install.
        let gitHookCount = resourceURLs.count

        // Get the URL to the ".git/hooks" directory for the repository we're in.
        let gitHooksDirectoryURL = try self.gitHooksDirectoryURL()

        // Loop through every fetched resource and install it into the ".git/hooks" directory.
        for resourceURL in resourceURLs {
            // Our filename should be the resource URL's last path component.
            let filename = resourceURL.lastPathComponent

            self.log("Installing '\(filename)' git hook...")

            // Append this filename to our directory URL to get our destination URL.
            let destinationURL = gitHooksDirectoryURL.appendingPathComponent(filename)

            // If a file already exists at the destination, delete it.
            if FileManager.default.fileExists(atPath: destinationURL.path) {
                try FileManager.default.removeItem(at: destinationURL)
            }

            // Finally, copy our resource to the destination.
            try FileManager.default.copyItem(at: resourceURL, to: destinationURL)
        }

        self.log("\(gitHookCount) git hooks installed.")
    }

    private func gitHooksDirectoryURL() throws -> URL {
        let command = "git rev-parse --git-dir"
        let output = try ConfiguredProcess.bash(command: command).run()
        let directoryURL = URL(fileURLWithPath: output, isDirectory: true)

        // Ensure our last path component is ".git".
        guard directoryURL.lastPathComponent == ".git" else {
            throw SetupCommandError.gitDirectoryNotFound
        }

        return directoryURL.appendingPathComponent("hooks")
    }
}

// MARK: - Supporting Types

enum SetupCommandError: LocalizedError {
    case gitDirectoryNotFound

    var errorDescription: String? {
        switch self {
        case .gitDirectoryNotFound:
            return ".git directory not found."
        }
    }
}

// MARK: - Extensions

private extension SetupCommand {
    /// An array of common git hooks.
    ///
    /// Reference: <https://git-scm.com/docs/githooks>
    static let availableGitHooks = [
        "applypatch-msg",
        "commit-msg",
        "post-applypatch",
        "post-checkout",
        "post-commit",
        "post-merge",
        "post-receive",
        "post-rewrite",
        "post-update",
        "pre-applypatch",
        "pre-auto-gc",
        "pre-commit",
        "pre-push",
        "pre-rebase",
        "pre-receive",
        "prepare-commit-msg",
        "push-to-checkout",
        "update",
    ]
}
