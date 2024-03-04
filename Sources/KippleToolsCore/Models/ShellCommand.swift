// Copyright © 2024 Brian Drelling. All rights reserved.

import Foundation

public struct ShellCommand {
    // MARK: Properties

    public let command: String
    public var arguments: [String]

    // MARK: Methods

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

// MARK: - Extensions

extension ShellCommand: CustomStringConvertible {
    public var description: String {
        "\(self.command) \(self.arguments.joined(separator: " "))"
    }
}
