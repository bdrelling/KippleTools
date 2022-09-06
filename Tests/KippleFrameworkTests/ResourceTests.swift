// Copyright © 2022 Brian Drelling. All rights reserved.

@testable import KippleFramework
import XCTest

final class ResourceTests: XCTestCase {
    func testEmptyPathReturnsDefault() throws {
        let path = try FileFormatter.shared.pathForConfigurationFile()

        // We don't want to use an absolute path here, but evaluating that a suffix exists is plenty
        // because it wouldn't have returned a path if the default file didn't exist.
        XCTAssertTrue(path.hasSuffix("/default.swiftformat"))
    }

    func testDefaultFileNameReturnsDefault() throws {
        let path = try FileFormatter.shared.pathForConfigurationFile("default.swiftformat")

        // We don't want to use an absolute path here, but evaluating that a suffix exists is plenty
        // because it wouldn't have returned a path if the default file didn't exist.
        XCTAssertTrue(path.hasSuffix("/default.swiftformat"))
    }

    func testDefaultFileExtensionOnlyReturnsDefault() throws {
        let path = try FileFormatter.shared.pathForConfigurationFile(".swiftformat")

        // We don't want to use an absolute path here, but evaluating that a suffix exists is plenty
        // because it wouldn't have returned a path if the default file didn't exist.
        XCTAssertTrue(path.hasSuffix("/default.swiftformat"))
    }

    func testNonExistentFilesThrowError() throws {
        XCTAssertThrowsError(try FileFormatter.shared.pathForConfigurationFile("does_not_exist.swiftformat"))
        XCTAssertThrowsError(try FileFormatter.shared.pathForConfigurationFile("whatever.txt"))
    }
}
