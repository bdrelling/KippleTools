// Copyright © 2022 Brian Drelling. All rights reserved.

@testable import KippleFormat
import XCTest

final class ResourceTests: XCTestCase {
    func testEmptyPathReturnsDefault() throws {
        let path = try FileFormatter.pathForConfigurationFile()
        
        // We don't want to use an absolute path here, but evaluating the suffix should be more than enough.
        XCTAssertTrue(path.hasSuffix("/Resources/KippleTools_KippleFormat.bundle/Contents/Resources/default.swiftformat"))
    }
    
    func testDefaultFileNameReturnsDefault() throws {
        let path = try FileFormatter.pathForConfigurationFile("default.swiftformat")
        
        // We don't want to use an absolute path here, but evaluating the suffix should be more than enough.
        XCTAssertTrue(path.hasSuffix("/Resources/KippleTools_KippleFormat.bundle/Contents/Resources/default.swiftformat"))
    }
    
    func testDefaultFileExtensionOnlyReturnsDefault() throws {
        let path = try FileFormatter.pathForConfigurationFile(".swiftformat")
        
        // We don't want to use an absolute path here, but evaluating the suffix should be more than enough.
        XCTAssertTrue(path.hasSuffix("/Resources/KippleTools_KippleFormat.bundle/Contents/Resources/default.swiftformat"))
    }
    
    func testNonExistentFilesThrowError() throws {
        XCTAssertThrowsError(try FileFormatter.pathForConfigurationFile("does_not_exist.swiftformat"))
        XCTAssertThrowsError(try FileFormatter.pathForConfigurationFile("whatever.txt"))
    }
}

//// Copyright © 2022 Brian Drelling. All rights reserved.
//
//import KippleToolsCore
//import XCTest
//
//final class FileClerkTests: XCTestCase {
//    func testAllConfigurationFilesAreInBundle() throws {
//        let files = ConfigurationFileClerk().configurationFiles
//
//        // Evaluate the total number of expected files in the bundle.
//        XCTAssertEqual(files.count, 2)
//    }
//
//    func testSwiftFormatFilesAreValid() throws {
//        try evaluate(.swiftformat, expectedNumberOfFiles: 1)
//    }
//
//    func testSwiftLintFilesAreValid() throws {
//        try evaluate(.swiftlint, expectedNumberOfFiles: 1)
//    }
//}
//
//// MARK: - Extensions
//
//private extension FileClerkTests {
//    func evaluate(_ tool: ConfigurationTool, expectedNumberOfFiles: Int) throws {
//        let files = ConfigurationFileClerk().configurationFiles.filter { $0.tool == tool }
//
//        // Evaluate the total number of expected files in the bundle.
//        XCTAssertEqual(files.count, expectedNumberOfFiles)
//
//        // There should be exactly one default file included in the bundle.
//        XCTAssertEqual(files.filter(\.isDefault).count, 1, "There must be exactly one default configuration file in the bundle.")
//    }
//}
