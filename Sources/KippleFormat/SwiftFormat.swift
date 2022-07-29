// Copyright © 2022 Brian Drelling. All rights reserved.

import Foundation
import SwiftFormat

final class SwiftFormat {
    private var stderr = FileHandle.standardError

    private let stderrIsTTY = isatty(STDERR_FILENO) != 0
    private let printQueue = DispatchQueue(label: "swiftformat.print")

    init() {
        CLI.print = self.print
    }

    func run(in workingDirectory: String = FileManager.default.currentDirectoryPath, arguments: [String] = ["."]) {
        // We need to get the first argument, which is typically the path to the current running command.
        // We pass this into SwiftFormat, which presumably then drops it to parse the remaining arguments.
        // Either way, this allows for consistency with SwiftFormat's functionality.
        guard let commandArgument = CommandLine.arguments.first else {
            return
        }

        _ = CLI.run(in: workingDirectory, with: [commandArgument] + arguments)
    }

    private func print(message: String, type: CLI.OutputType) {
        self.printQueue.sync {
            switch type {
            case .info:
                Swift.print(message, to: &stderr)
            case .success:
                Swift.print(stderrIsTTY ? message.inGreen : message, to: &stderr)
            case .error:
                Swift.print(stderrIsTTY ? message.inRed : message, to: &stderr)
            case .warning:
                Swift.print(stderrIsTTY ? message.inYellow : message, to: &stderr)
            case .content:
                Swift.print(message)
            case .raw:
                Swift.print(message, terminator: "")
            }
        }
    }
}

// MARK: - Extensions

private extension String {
    var inDefault: String { "\u{001B}[39m\(self)" }
    var inRed: String { "\u{001B}[31m\(self)\u{001B}[0m" }
    var inGreen: String { "\u{001B}[32m\(self)\u{001B}[0m" }
    var inYellow: String { "\u{001B}[33m\(self)\u{001B}[0m" }
}

extension FileHandle: TextOutputStream {
    public func write(_ string: String) {
        self.write(Data(string.utf8))
    }
}
