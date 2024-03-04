// Copyright © 2024 Brian Drelling. All rights reserved.

import Foundation

public struct Shell {
    private let executablePath: String
    private let outputPipe: Pipe

    private init(
        executablePath: String,
        outputPipe: Pipe = .init()
    ) {
        self.executablePath = executablePath
        self.outputPipe = outputPipe
    }

    @discardableResult
    public func callAsFunction(
        _ command: String,
        arguments: [String] = [],
        environment: [String: String]? = nil,
        at workingDirectory: String? = nil,
        isVerbose: Bool = false,
        outputHandle: FileHandle? = nil,
        errorHandle: FileHandle? = nil
    ) throws -> String {
        let process = Process(
            executablePath: self.executablePath,
            command: command,
            arguments: arguments,
            environment: environment,
            at: workingDirectory
        )

        return try process.execute(
            isVerbose: isVerbose,
            outputHandle: outputHandle,
            errorHandle: errorHandle
        )
    }

    @discardableResult
    public func callAsFunction(
        _ command: ShellCommand,
        environment: [String: String]? = nil,
        at workingDirectory: String? = nil,
        isVerbose: Bool = false,
        outputHandle: FileHandle? = nil,
        errorHandle: FileHandle? = nil
    ) throws -> String {
        try self.callAsFunction(
            command.command,
            arguments: command.arguments,
            environment: environment,
            at: workingDirectory,
            isVerbose: isVerbose,
            outputHandle: outputHandle,
            errorHandle: errorHandle
        )
    }
}

// MARK: - Convenience

public extension Shell {
    static let `default`: Self = .bash

    static let sh: Self = .init(executablePath: "/bin/sh")
    static let bash: Self = .init(executablePath: "/bin/bash")
    static let zsh: Self = .init(executablePath: "/bin/zsh")
}
