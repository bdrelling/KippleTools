// Copyright © 2024 Brian Drelling. All rights reserved.

import Foundation

// git config --global user.email "you@example.com"
// git config --global user.name "Your Name"
public extension ShellCommand {
    private static func git(allowingPrompt: Bool) -> Self {
        .init(allowingPrompt ? "git" : "env GIT_TERMINAL_PROMPT=0 git")
    }

    /// Initialize a git repository.
    static func gitInit() -> ShellCommand {
        .init("git init")
    }

    /// Clone a git repository at a given URL
    static func gitClone(url: URL, to path: String? = nil, allowingPrompt: Bool = true) -> Self {
        var command: Self = .git(allowingPrompt: allowingPrompt).appending("clone \(url.absoluteString)")
        path.map { command.append($0) }
        command.append("--quiet")

        return command
    }

    /// Create a git commit with a given message (also adds all untracked file to the index)
    static func gitCommit(message: String, allowingPrompt: Bool = true) -> Self {
        .git(allowingPrompt: allowingPrompt).appending("add . && git commit -a -m")
            .appending(message)
            .appending("--quiet")
    }

    /// Perform a git push
    static func gitPush(remote: String? = nil, branch: String? = nil, allowingPrompt: Bool = true) -> Self {
        var command: Self = .git(allowingPrompt: allowingPrompt).appending("push")
        remote.map { command.append($0) }
        branch.map { command.append($0) }
        command.append("--quiet")

        return command
    }

    /// Perform a git pull
    static func gitPull(remote: String? = nil, branch: String? = nil, allowingPrompt: Bool = true) -> Self {
        var command: Self = .git(allowingPrompt: allowingPrompt).appending("pull")
        remote.map { command.append($0) }
        branch.map { command.append($0) }
        command.append("--quiet")

        return command
    }

    /// Run a git submodule update
    static func gitSubmoduleUpdate(initializeIfNeeded: Bool = true, recursive: Bool = true, allowingPrompt: Bool = true) -> Self {
        var command: Self = .git(allowingPrompt: allowingPrompt).appending("submodule update")

        if initializeIfNeeded {
            command.append("--init")
        }

        if recursive {
            command.append("--recursive")
        }

        command.append("--quiet")

        return command
    }

    /// Checkout a given git branch
    static func gitCheckout(branch: String) -> Self {
        .init("git checkout", arguments: [branch, "--quiet"])
    }

    /// Runs an action of the `git config` subcommand.
    static func gitConfig(_ action: String, config: GitConfig? = nil, allowingPrompt: Bool = true) -> Self {
        var command: Self = .git(allowingPrompt: allowingPrompt)
            .appending("config")

        if let config {
            command.append("--\(config.rawValue)")
        }

        command.append(action)

        return command
    }

    static func gitConfig(_ action: GitConfigAction = .help, config: GitConfig = .local, allowingPrompt: Bool = true) -> Self {
        self.gitConfig(action.rawValue, config: config, allowingPrompt: allowingPrompt)
    }
}

// MARK: - Supporting Types

public enum GitConfig: String {
    /// Use global config file.
    case global

    /// Use global config file.
    case system

    /// Use global config file.
    case local
}

public enum GitConfigAction {
    case help
    case get(_ name: String)
    case add(_ name: String, value: String)
    case unset(_ name: String)
    case list

    var rawValue: String {
        switch self {
        case .help: "--help"
        case let .get(name): "--get \(name)"
        case let .add(name, value): "--add \(name) \(value)"
        case let .unset(name): "--unset \(name)"
        case .list: "--list"
        }
    }
}
