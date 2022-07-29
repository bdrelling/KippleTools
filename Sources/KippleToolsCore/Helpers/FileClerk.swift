// Copyright © 2022 Brian Drelling. All rights reserved.

import Foundation

public class FileClerk {
    // MARK: Properties

    public private(set) var configurationFiles: [ConfigurationFile] = []

    // MARK: Initializers

    public init(bundle: Bundle? = nil) {
        let bundle = bundle ?? .module
        self.configurationFiles = ConfigurationTool.allCases.flatMap { self.bundledConfigurationFiles(for: $0, in: bundle) }
    }

    // MARK: Methods

    private func bundledConfigurationFiles(for tool: ConfigurationTool, in bundle: Bundle) -> [ConfigurationFile] {
        bundle.paths(forResourcesOfType: tool.fileExtension, inDirectory: nil).compactMap { path in
            if let name = path.split(separator: "/").last?.replacingOccurrences(of: ".\(tool.fileExtension)", with: "") {
                return ConfigurationFile(tool, name: name, path: path)
            } else {
                return nil
            }
        }
    }

    public func configurationFiles(for tool: ConfigurationTool) -> [ConfigurationFile] {
        let files = self.configurationFiles
        let file = files.filter { $0.tool == tool }
        return file
    }

    public func configurationFiles(for tool: String) -> [ConfigurationFile] {
        guard let tool = ConfigurationTool(rawValue: tool) else {
            return []
        }

        return self.configurationFiles(for: tool)
    }

    public func configurationFile(for tool: ConfigurationTool, named name: String?) -> ConfigurationFile? {
        let name = name ?? ConfigurationFile.defaultFileName

        let files = self.configurationFiles(for: tool)
        let firstFile = files.first { $0.name == name }

        return firstFile
    }

    public func configurationFile(for tool: String, named name: String?) -> ConfigurationFile? {
        guard let tool = ConfigurationTool(rawValue: tool) else {
            return nil
        }

        return self.configurationFile(for: tool, named: name)
    }

    public func defaultConfigurationFile(for tool: ConfigurationTool) -> ConfigurationFile? {
        self.configurationFile(for: tool, named: "default")
    }

    public func defaultConfigurationFile(for tool: String) -> ConfigurationFile? {
        self.configurationFile(for: tool, named: "default")
    }
}
