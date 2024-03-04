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
        #if os(Linux)
        throw XCTSkip("zsh is not preinstalled on Linux, so we run this test on macOS only.")
        #endif

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
        #if os(Linux)
        throw XCTSkip("Capturing output via file handle is not working properly on Linux right now.")
        #endif

        let pipe = Pipe()
        let output = try sh("echo", arguments: ["Hello"], outputHandle: pipe.fileHandleForWriting)
        let capturedData = pipe.fileHandleForReading.readDataToEndOfFile()
        XCTAssertEqual(output, "Hello")
        XCTAssertEqual(output + "\n", String(data: capturedData, encoding: .utf8))
    }

    func testCapturingErrorWithHandle() throws {
        #if os(Linux)
        throw XCTSkip("Capturing error output via file handle is not working properly on Linux at this time.")
        #endif

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
}
