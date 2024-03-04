// Copyright © 2024 Brian Drelling. All rights reserved.

import Foundation

public extension ShellCommand {
    static func readFile(at path: String) -> Self {
        .init("cat", arguments: [path])
    }

    static func listContents(of directory: String) -> Self {
        .init("ls", arguments: [directory])
    }

    /// Create a folder with a given name
    static func createFolder(named name: String) -> Self {
        .init("mkdir", arguments: [name])
    }

    /// Create a file with a given name and contents (will overwrite any existing file with the same name)
    static func createFile(named name: String, contents: String) -> Self {
        .init("echo", arguments: [contents, " > ", name])
    }

//    /// Move a file from one path to another
//    static func moveFile(from originPath: String, to targetPath: String) -> Self {
//        let command = "mv".appending(argument: originPath)
//            .appending(argument: targetPath)
//
//        return .init(command)
//    }
//
//    /// Copy a file from one path to another
//    static func copyFile(from originPath: String, to targetPath: String) -> Self {
//        let command = "cp".appending(argument: originPath)
//            .appending(argument: targetPath)
//
//        return .init(command)
//    }
//
//    /// Remove a file
//    static func removeFile(from path: String, arguments: [String] = ["-f"]) -> Self {
//        let command = "rm".appending(arguments: arguments)
//            .appending(argument: path)
//
//        return .init(command)
//    }
//
//    /// Open a file using its designated application
//    static func openFile(at path: String) -> Self {
//        let command = "open".appending(argument: path)
//        return .init(command)
//    }
//
//    /// Read a file as a string
//    static func readFile(at path: String) -> Self {
//        let command = "cat".appending(argument: path)
//        return .init(command)
//    }
//
//    /// Create a symlink at a given path, to a given target
//    static func createSymlink(to targetPath: String, at linkPath: String) -> Self {
//        let command = "ln -s".appending(argument: targetPath)
//            .appending(argument: linkPath)
//
//        return .init(command)
//    }
//
//    /// Expand a symlink at a given path, returning its target path
//    static func expandSymlink(at path: String) -> Self {
//        let command = "readlink".appending(argument: path)
//        return .init(command)
//    }
}
