// Copyright © 2022 Brian Drelling. All rights reserved.

import Foundation

public class FileClerk {
    // MARK: Shared Instance

    public static let shared = FileClerk()

    // MARK: Properties

    public private(set) var configurationFiles: [ConfigurationFile] = []

    // MARK: Initializers

    private init() {
        self.configurationFiles = ConfigurationTool.allCases.flatMap(self.bundledConfigurationFiles)
    }

    // MARK: Methods

    private func bundledConfigurationFiles(for tool: ConfigurationTool) -> [ConfigurationFile] {
        Bundle.module.paths(forResourcesOfType: tool.fileExtension, inDirectory: nil).compactMap { path in
            if let name = path.split(separator: "/").last?.replacingOccurrences(of: ".\(tool.fileExtension)", with: "") {
                return ConfigurationFile(tool, name: name, path: path)
            } else {
                return nil
            }
        }
    }

    public func configurationFiles(for tool: ConfigurationTool) -> [ConfigurationFile] {
        self.configurationFiles.filter { $0.tool == tool }
    }

    public func configurationFiles(for tool: String) -> [ConfigurationFile] {
        guard let tool = ConfigurationTool(rawValue: tool) else {
            return []
        }

        return self.configurationFiles(for: tool)
    }

    public func configurationFile(for tool: ConfigurationTool, named name: String?) -> ConfigurationFile? {
        let name = name ?? ConfigurationFile.defaultFileName

        return self.configurationFiles(for: tool).first { $0.name == name }
    }

    public func configurationFile(for tool: String, named name: String?) -> ConfigurationFile? {
        guard let tool = ConfigurationTool(rawValue: tool) else {
            return nil
        }

        return self.configurationFile(for: tool, named: name)
    }
}
