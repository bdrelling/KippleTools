// Copyright © 2022 Brian Drelling. All rights reserved.

public struct ConfigurationFile: Codable {
    public static let defaultFileName = "default"

    public let tool: ConfigurationTool
    public let name: String
    public let path: String

    public var isDefault: Bool {
        self.name == Self.defaultFileName
    }

    init(
        _ tool: ConfigurationTool,
        name: String,
        path: String
    ) {
        self.tool = tool
        self.name = name
        self.path = path
    }
}
