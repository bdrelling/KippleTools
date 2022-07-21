// Copyright © 2022 Brian Drelling. All rights reserved.

public enum ConfigurationTool: String, Codable, CaseIterable {
    case swiftformat
    case swiftlint

    var fileExtension: String {
        switch self {
        case .swiftformat:
            return "swiftformat"
        case .swiftlint:
            return "swiftlint.yml"
        }
    }
}
