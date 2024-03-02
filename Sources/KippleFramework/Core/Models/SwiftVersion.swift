// Copyright © 2024 Brian Drelling. All rights reserved.

import ArgumentParser

enum SwiftVersion: Double, CaseIterable, ExpressibleByArgument {
    case v5_7 = 5.7
    case v5_8 = 5.8
    case v5_9 = 5.9
    case v5_10 = 5.10
    case v6 = 6
}

// MARK: - Convenience

extension SwiftVersion {
    // TODO: Delete -- this would likely just cause issues.
    // static let latest: Self = .allCases.last ?? .v5_9

    static let current: Self = {
        #if swift(>=6)
        print("WARNING: Swift 6 is not yet supported by KippleTools; please use with caution.")
            .v6
        #elseif swift(>=5.10)
        .v5_10
        #elseif swift(>=5.9)
        .v5_9
        #elseif swift(>=5.8)
        .v5_8
        #elseif swift(>=5.7)
        .v5_7
        #else
        fatalError("Swift 5.7 or greater is required to run KippleTools.")
        #endif
    }()
}

// MARK: - Extensions

extension SwiftVersion: CustomStringConvertible {
    var description: String {
        .init(self.rawValue)
    }
}
