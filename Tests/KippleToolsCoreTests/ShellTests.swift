// Copyright © 2024 Brian Drelling. All rights reserved.

@testable import KippleToolsCore
import XCTest

final class ShellTests: XCTestCase {
    // MARK: Properties

    private let sh: Shell = .default

    // MARK: Tests

    func testShellCommandRuns() throws {
        let shell: Shell = .sh
        let output = try shell("echo Hello, world!")
        XCTAssertEqual(output, "Hello, world!")
    }

    func testBashCommandRuns() throws {
        let shell: Shell = .bash
        let output = try shell("echo Hello, world!")
        XCTAssertEqual(output, "Hello, world!")
    }

    func testZshCommandRuns() throws {
        let shell: Shell = .zsh
        let output = try shell("echo Hello, world!")
        XCTAssertEqual(output, "Hello, world!")
    }

    func testWithoutArguments() throws {
        let uptime = try sh("uptime")
        XCTAssertTrue(uptime.contains("load average"))
    }

    func testWithArguments() throws {
        let echo = try sh("echo", arguments: ["Hello world"])
        XCTAssertEqual(echo, "Hello world")
    }

    func testWithInlineArguments() throws {
        let echo = try sh("echo \"Hello world\"")
        XCTAssertEqual(echo, "Hello world")
    }

    func testSingleCommandAtPath() throws {
        try self.sh("echo \"Hello\" > \(NSTemporaryDirectory())ShellOutTests-SingleCommand.txt")

        let textFileContent = try sh("cat ShellOutTests-SingleCommand.txt", at: NSTemporaryDirectory())

        XCTAssertEqual(textFileContent, "Hello")
    }

    func testSingleCommandAtPathContainingSpace() throws {
        try self.sh("mkdir -p \"ShellOut Test Folder\"", at: NSTemporaryDirectory())
        try self.sh("echo \"Hello\" > File", at: NSTemporaryDirectory() + "ShellOut Test Folder")

        let output = try sh("cat \(NSTemporaryDirectory())ShellOut\\ Test\\ Folder/File")
        XCTAssertEqual(output, "Hello")
    }

//    func testSingleCommandAtPathContainingTilde() throws {
//        let homeContents = try sh("ls", workingDirectory: "~")
//        XCTAssertFalse(homeContents.isEmpty)
//    }

//    func testSeriesOfCommands() throws {
//        let echo = try sh(["echo \"Hello\"", "echo \"world\""])
//        XCTAssertEqual(echo, "Hello\nworld")
//    }

//    func testSeriesOfCommandsAtPath() throws {
//        try sh([
//            "cd \(NSTemporaryDirectory())",
//            "mkdir -p ShellOutTests",
//            "echo \"Hello again\" > ShellOutTests/MultipleCommands.txt",
//        ])
//
//        let textFileContent = try sh([
//            "cd ShellOutTests",
//            "cat MultipleCommands.txt",
//        ], workingDirectory: NSTemporaryDirectory())
//
//        XCTAssertEqual(textFileContent, "Hello again")
//    }

    func testThrowingError() {
        do {
            try self.sh("cd", arguments: ["notADirectory"])
            XCTFail("Expected expression to throw")
        } catch let error as ShellError {
            XCTAssertTrue(error.message.contains("notADirectory"))
            XCTAssertTrue(error.output.isEmpty)
            XCTAssertTrue(error.terminationStatus != 0)
        } catch {
            XCTFail("Invalid error type: \(error)")
        }
    }

    func testErrorDescription() {
        let errorMessage = "Hey, I'm an error!"
        let output = "Some output"

        let error = ShellError(
            terminationStatus: 7,
            errorData: errorMessage.data(using: .utf8)!,
            outputData: output.data(using: .utf8)!
        )

        let expectedErrorDescription = """
        Shell encountered an error...
        Status code: 7
        Message: "Hey, I'm an error!"
        Output: "Some output"
        """

        XCTAssertEqual("\(error)", expectedErrorDescription)
        XCTAssertEqual(error.localizedDescription, expectedErrorDescription)
    }

    func testCapturingOutputWithHandle() throws {
        let pipe = Pipe()
        let output = try sh("echo", arguments: ["Hello"], outputHandle: pipe.fileHandleForWriting)
        let capturedData = pipe.fileHandleForReading.readDataToEndOfFile()
        XCTAssertEqual(output, "Hello")
        XCTAssertEqual(output + "\n", String(data: capturedData, encoding: .utf8))
    }

    func testCapturingErrorWithHandle() throws {
        let pipe = Pipe()

        do {
            try self.sh("cd", arguments: ["notADirectory"], errorHandle: pipe.fileHandleForWriting)
            XCTFail("Expected expression to throw")
        } catch let error as ShellError {
            XCTAssertTrue(error.message.contains("notADirectory"))
            XCTAssertTrue(error.output.isEmpty)
            XCTAssertTrue(error.terminationStatus != 0)

            let capturedData = pipe.fileHandleForReading.readDataToEndOfFile()
            XCTAssertEqual(error.message + "\n", String(data: capturedData, encoding: .utf8))
        } catch {
            XCTFail("Invalid error type: \(error)")
        }
    }

    // MARK: Convenience Commands

    func testFileSystemCommands() throws {
        let contents = try sh(.listContents(of: "."))
        XCTAssertFalse(contents.isEmpty)
    }

    func testGitCommands() throws {
        // Setup & clear state
        let tempFolderPath = NSTemporaryDirectory()
        try sh("rm -rf GitTestOrigin", at: tempFolderPath)
        try sh("rm -rf GitTestClone", at: tempFolderPath)

        // Create a origin repository and make a commit with a file
        let originPath = tempFolderPath + "/GitTestOrigin"
        try sh(.createFolder(named: "GitTestOrigin"), at: tempFolderPath)
        try sh(.gitInit(), at: originPath)
        try sh(.createFile(named: "Test", contents: "Hello world"), at: originPath)
        try sh(.gitCommit(message: "Commit"), at: originPath)

        // Clone to a new repository and read the file
        let clonePath = tempFolderPath + "/GitTestClone"
        let cloneURL = URL(fileURLWithPath: originPath)
        try sh(.gitClone(url: cloneURL, to: "GitTestClone"), at: tempFolderPath)

        let filePath = clonePath + "/Test"
        XCTAssertEqual(try self.sh(.readFile(at: filePath)), "Hello world")

        // Make a new commit in the origin repository
        try self.sh(.createFile(named: "Test", contents: "Hello again"), at: originPath)
        try self.sh(.gitCommit(message: "Commit"), at: originPath)

        // Pull the commit in the clone repository and read the file again
        try self.sh(.gitPull(), at: clonePath)
        XCTAssertEqual(try self.sh(.readFile(at: filePath)), "Hello again")
    }

    func testSwiftPackageManagerCommands() throws {
        // Setup & clear state
        let tempFolderPath = NSTemporaryDirectory()
        try sh("rm -rf SwiftPackageManagerTest", at: tempFolderPath)
        try sh(.createFolder(named: "SwiftPackageManagerTest"), at: tempFolderPath)

        // Create a Swift package and verify that it has a Package.swift file
        let packagePath = tempFolderPath + "/SwiftPackageManagerTest"
        try sh(.createSwiftPackage(), at: packagePath)
        XCTAssertFalse(try self.sh(.readFile(at: packagePath + "/Package.swift")).isEmpty)

        // Build the package and verify that there's a .build folder
        try self.sh(.buildSwiftPackage(), at: packagePath)
        XCTAssertTrue(try self.sh("ls -a", at: packagePath).contains(".build"))
    }
}
