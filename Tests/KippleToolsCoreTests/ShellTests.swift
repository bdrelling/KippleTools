// Copyright © 2024 Brian Drelling. All rights reserved.

import KippleToolsCore
import XCTest

final class ShellTests: XCTestCase {
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
}
