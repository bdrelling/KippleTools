// Copyright © 2024 Brian Drelling. All rights reserved.

@testable import KippleToolsCore
import XCTest

final class ShellCommandTests: XCTestCase {
    // MARK: Properties

    private let sh: Shell = .default

    // MARK: Tests

    func testFileSystemCommands() throws {
        let contents = try sh(.listContents(of: "."))
        XCTAssertFalse(contents.isEmpty)
    }

    func testGitCommands() throws {
        // Setup & clear state
        let tempFolderPath = NSTemporaryDirectory()
        try sh("rm -rf GitTestOrigin", at: tempFolderPath)
        try sh("rm -rf GitTestClone", at: tempFolderPath)

        // Create our origin folder.
        let originPath = tempFolderPath + "/GitTestOrigin"
        try sh(.createFolder(named: "GitTestOrigin"), at: tempFolderPath)

        // Git config is necessary for our CI tests on Linux.
        #if os(Linux)
        try sh(.gitConfig(.add("user.email", value: "tester@github.actions.com"), config: .local), at: originPath)
        try sh(.gitConfig(.add("user.name", value: "GitHub Actions"), config: .local), at: originPath)
        #endif

        // Create a origin repository and make a commit with a file
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
