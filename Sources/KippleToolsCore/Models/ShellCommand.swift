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
