// Copyright © 2022 Brian Drelling. All rights reserved.

import Foundation

enum FormatError: Error {
    case configurationFileNotDetected
    case configurationFileNotFound(String)
}

extension FormatError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .configurationFileNotDetected:
            return """
            SwiftFormat configuration file could not be detected.
            Either ensure a .swiftformat file is located in this directory, or pass the file into the command using the --config option.
            """
        case let .configurationFileNotFound(file):
            return "SwiftFormat configuration file '\(file)' could not be found. If you meant to pass it as a file instead, try './\(file)'."
        }
    }
}
