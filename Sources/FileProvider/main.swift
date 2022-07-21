// Copyright © 2022 Brian Drelling. All rights reserved.

import Foundation
import PluginCore

// MARK: - Main

// First, get the arguments for the command.
let arguments = try getArguments()

// Then, print the applicable file string to the console.
try printFileString(for: arguments)

// MARK: - Supporting Types

struct Arguments {
    var tool: String
    var fileName: String?
}

enum FileProviderError: Error {
    case argumentsNotFound
    case argumentNotFound(String)
    case fileNotFound(tool: String, name: String?)
}

// MARK: - Methods

func getArguments() throws -> Arguments {
    // The first argument fetched by the process is always the executable path.
    // This must be cast to an Array -- an ArraySlice simply drops the first index but retains the existing indexes,
    // so count == 2 but accessing array element 0 throws an error.
    let arguments = Array(ProcessInfo.processInfo.arguments.dropFirst())

    guard arguments.count > 0 else {
        throw FileProviderError.argumentsNotFound
    }

    // Get the first argument from the list, which should correspond to the tool.
    guard let tool = arguments.first else {
        throw FileProviderError.argumentNotFound("tool")
    }

    // Get the second argument from the list, which should correspond to the file name to use.
    // This value is optional and will be set to the default if passed as nil.
    let fileName = arguments.count == 2 ? arguments[1] : nil

    return .init(tool: tool, fileName: fileName)
}

func printFileString(for arguments: Arguments) throws {
    guard let file = FileClerk.shared.configurationFile(for: arguments.tool, named: arguments.fileName) else {
        throw FileProviderError.fileNotFound(tool: arguments.tool, name: arguments.fileName)
    }

    // Print this data to the console in an environment variable format.
    // Plugins can detect this line and access directly.
    print("PLUGIN_FILE_PATH=\(file.path)")
}
