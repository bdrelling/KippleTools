// Copyright © 2024 Brian Drelling. All rights reserved.

import KippleToolsCore

enum BuildEnvironment {
    /// Returns the version of Swift currently detected by `swift --version`.
    ///
    /// Note: This command always seems to print `"swift-driver version: 1.87.3"` out into the console,
    /// regardless as to how the output is captured for the process.
    static func currentSwiftVersion(sh: Shell = .default) throws -> SwiftVersion? {
        let command = #"swift --version | sed -nE 's/.*Swift version ([0-9]+\.[0-9]+).*/\1/p'"#
        let rawValue = try sh(command)
        return .init(argument: rawValue)
    }
}
