// Copyright © 2024 Brian Drelling. All rights reserved.

import Foundation
@_implementationOnly import ShellOut

public extension Process {
    // MARK: Initializers

    convenience init(
        executablePath: String,
        arguments: [String]? = nil,
        environment: [String: String]? = nil,
        at workingDirectory: String? = nil
    ) {
        self.init()

        // Set the executable path for the process.
        self.executableURL = URL(fileURLWithPath: executablePath)

        // Set arguments for the process.
        self.arguments = arguments

        // Load environment variables into the process.
        self.environment = environment

        // Set the working directory for the process.
        if let workingDirectory = workingDirectory {
            self.currentDirectoryURL = URL(fileURLWithPath: workingDirectory, isDirectory: true)
        }
    }

    convenience init(
        executablePath: String,
        command: String,
        arguments: [String] = [],
        environment: [String: String]? = nil,
        at workingDirectory: String? = nil
    ) {
        // Our arguments have to be printed alongside the command so they are processed properly.
        let commandWithArguments = ([command] + arguments).joined(separator: " ")

        self.init(
            executablePath: executablePath,
            arguments: ["-c", commandWithArguments],
            environment: environment,
            at: workingDirectory
        )
    }

    convenience init(
        executablePath: String,
        command: ShellCommand,
        environment: [String: String]? = nil,
        at workingDirectory: String? = nil
    ) {
        self.init(
            executablePath: executablePath,
            command: command.command,
            arguments: command.arguments,
            environment: environment,
            at: workingDirectory
        )
    }

    // MARK: Methods

    // Source: https://github.com/JohnSundell/ShellOut
    @discardableResult
    func execute(outputHandle: FileHandle? = nil, errorHandle: FileHandle? = nil) throws -> String {
        // Because FileHandle's readabilityHandler might be called from a
        // different queue from the calling queue, avoid a data race by
        // protecting reads and writes to outputData and errorData on
        // a single dispatch queue.
        let outputQueue = DispatchQueue(label: "bash-output-queue")

        var outputData = Data()
        var errorData = Data()

        let outputPipe = Pipe()
        standardOutput = outputPipe

        let errorPipe = Pipe()
        standardError = errorPipe

        #if !os(Linux)
        outputPipe.fileHandleForReading.readabilityHandler = { handler in
            let data = handler.availableData
            outputQueue.async {
                outputData.append(data)
                outputHandle?.write(data)
            }
        }

        errorPipe.fileHandleForReading.readabilityHandler = { handler in
            let data = handler.availableData
            outputQueue.async {
                errorData.append(data)
                errorHandle?.write(data)
            }
        }
        #endif

        try self.run()

        #if os(Linux)
        outputQueue.sync {
            outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
            errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
        }
        #endif

        waitUntilExit()

        if let handle = outputHandle, !handle.isStandard {
            handle.closeFile()
        }

        if let handle = errorHandle, !handle.isStandard {
            handle.closeFile()
        }

        #if !os(Linux)
        outputPipe.fileHandleForReading.readabilityHandler = nil
        errorPipe.fileHandleForReading.readabilityHandler = nil
        #endif

        // Block until all writes have occurred to outputData and errorData,
        // and then read the data back out.
        return try outputQueue.sync {
            if terminationStatus != 0 {
                throw ShellError(
                    terminationStatus: terminationStatus,
                    errorData: errorData,
                    outputData: outputData
                )
            }

            return outputData.shellOutput()
        }
    }
}

// MARK: - Extensions

private extension FileHandle {
    var isStandard: Bool {
        self === FileHandle.standardOutput ||
            self === FileHandle.standardError ||
            self === FileHandle.standardInput
    }
}

private extension String {
    var escapingSpaces: String {
        replacingOccurrences(of: " ", with: "\\ ")
    }

    func appending(argument: String) -> String {
        "\(self) \"\(argument)\""
    }

    func appending(arguments: [String]) -> String {
        self.appending(argument: arguments.joined(separator: "\" \""))
    }

    mutating func append(argument: String) {
        self = self.appending(argument: argument)
    }

    mutating func append(arguments: [String]) {
        self = self.appending(arguments: arguments)
    }
}
