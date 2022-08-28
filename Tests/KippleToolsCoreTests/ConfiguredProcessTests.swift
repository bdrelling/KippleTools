// Copyright © 2022 Brian Drelling. All rights reserved.

import KippleToolsCore
import XCTest

final class ConfiguredProcessTests: XCTestCase {
    func testConfiguredProcessRuns() throws {
        let process: ConfiguredProcess = .bash(command: "echo Hello, world!")
        let output = try process.run()
        XCTAssertEqual(output, "Hello, world!")
    }
}
