// Copyright © 2024 Brian Drelling. All rights reserved.

import Foundation

public struct ShellError: Swift.Error {
    /// The termination status of the command that was run
    public let terminationStatus: Int32
    /// The error message as a UTF8 string, as returned through `STDERR`
    public var message: String { self.errorData.shellOutput() }
    /// The raw error buffer data, as returned through `STDERR`
    public let errorData: Data
    /// The raw output buffer data, as retuned through `STDOUT`
    public let outputData: Data
    /// The output of the command as a UTF8 string, as returned through `STDOUT`
    public var output: String { self.outputData.shellOutput() }
}

extension ShellError: CustomStringConvertible {
    public var description: String {
        """
        Shell encountered an error...
        Status code: \(self.terminationStatus)
        Message: "\(self.message)"
        Output: "\(self.output)"
        """
    }
}

extension ShellError: LocalizedError {
    public var errorDescription: String? {
        self.description
    }
}
