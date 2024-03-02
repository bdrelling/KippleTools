// Copyright © 2024 Brian Drelling. All rights reserved.

import Foundation

public struct ShellCommand {
    public let command: String
    public var arguments: [String]

    init(_ command: String, arguments: [String] = []) {
        self.command = command
        self.arguments = arguments
    }

    func appending(_ arguments: [String]) -> Self {
        .init(self.command, arguments: self.arguments + arguments)
    }

    func appending(_ argument: String) -> Self {
        self.appending([argument])
    }

    mutating func append(_ arguments: [String]) {
        self = self.appending(arguments)
    }

    mutating func append(_ argument: String) {
        self = self.appending(argument)
    }
}

// MARK: - File System

public extension ShellCommand {
    static func readFile(at path: String) -> Self {
        .init("cat", arguments: [path])
    }

    static func listContents(of directory: String) -> Self {
        .init("ls", arguments: [directory])
    }

    /// Create a folder with a given name
    static func createFolder(named name: String) -> Self {
        .init("mkdir", arguments: [name])
    }

    /// Create a file with a given name and contents (will overwrite any existing file with the same name)
    static func createFile(named name: String, contents: String) -> Self {
        .init("echo", arguments: [contents, " > ", name])
    }

//    /// Move a file from one path to another
//    static func moveFile(from originPath: String, to targetPath: String) -> ShellOutCommand {
//        let command = "mv".appending(argument: originPath)
//            .appending(argument: targetPath)
//
//        return ShellOutCommand(string: command)
//    }
//
//    /// Copy a file from one path to another
//    static func copyFile(from originPath: String, to targetPath: String) -> ShellOutCommand {
//        let command = "cp".appending(argument: originPath)
//            .appending(argument: targetPath)
//
//        return ShellOutCommand(string: command)
//    }
//
//    /// Remove a file
//    static func removeFile(from path: String, arguments: [String] = ["-f"]) -> ShellOutCommand {
//        let command = "rm".appending(arguments: arguments)
//            .appending(argument: path)
//
//        return ShellOutCommand(string: command)
//    }
//
//    /// Open a file using its designated application
//    static func openFile(at path: String) -> ShellOutCommand {
//        let command = "open".appending(argument: path)
//        return ShellOutCommand(string: command)
//    }
//
//    /// Read a file as a string
//    static func readFile(at path: String) -> ShellOutCommand {
//        let command = "cat".appending(argument: path)
//        return ShellOutCommand(string: command)
//    }
//
//    /// Create a symlink at a given path, to a given target
//    static func createSymlink(to targetPath: String, at linkPath: String) -> ShellOutCommand {
//        let command = "ln -s".appending(argument: targetPath)
//            .appending(argument: linkPath)
//
//        return ShellOutCommand(string: command)
//    }
//
//    /// Expand a symlink at a given path, returning its target path
//    static func expandSymlink(at path: String) -> ShellOutCommand {
//        let command = "readlink".appending(argument: path)
//        return ShellOutCommand(string: command)
//    }
}

// MARK: - Git

public extension ShellCommand {
    /// Initialize a git repository
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

    private static func git(allowingPrompt: Bool) -> Self {
        .init(allowingPrompt ? "git" : "env GIT_TERMINAL_PROMPT=0 git")
    }
}

// MARK: - Swift Package Manager

public extension ShellCommand {
    /// Enum defining available package types when using the Swift Package Manager
    enum SwiftPackageType: String {
        case library
        case executable
    }

    /// Enum defining available build configurations when using the Swift Package Manager
    enum SwiftBuildConfiguration: String {
        case debug
        case release
    }

    /// Create a Swift package with a given type (see SwiftPackageType for options)
    static func createSwiftPackage(withType type: SwiftPackageType = .library) -> Self {
        .init("swift package init --type \(type.rawValue)")
    }

    /// Update all Swift package dependencies
    static func updateSwiftPackages() -> Self {
        .init("swift package update")
    }

    /// Generate an Xcode project for a Swift package
    static func generateSwiftPackageXcodeProject() -> Self {
        .init("swift package generate-xcodeproj")
    }

    /// Build a Swift package using a given configuration (see SwiftBuildConfiguration for options)
    static func buildSwiftPackage(withConfiguration configuration: SwiftBuildConfiguration = .debug) -> Self {
        .init("swift build -c \(configuration.rawValue)")
    }

    /// Test a Swift package using a given configuration (see SwiftBuildConfiguration for options)
    static func testSwiftPackage(withConfiguration configuration: SwiftBuildConfiguration = .debug) -> Self {
        .init("swift test -c \(configuration.rawValue)")
    }
}
