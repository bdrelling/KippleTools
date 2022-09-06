// Copyright © 2022 Brian Drelling. All rights reserved.

/// A simplified logger that facilitates printing to the console.
/// If our needs become more complex, we should integrate `swift-log` instead.
public protocol VerboseLogging {
    var isVerbose: Bool { get }

    func log(_ message: String, ignoresVerbose: Bool)
}

// MARK: - Extensions

public extension VerboseLogging {
    func log(_ message: String, ignoresVerbose: Bool = false) {
        guard ignoresVerbose || self.isVerbose else {
            return
        }

        print(message)
    }
}
