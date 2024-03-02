// Copyright © 2024 Brian Drelling. All rights reserved.

import ArgumentParser

enum Platform: String, CaseIterable, ExpressibleByArgument {
    case iOS
    case macOS
    case tvOS
    case visionOS
    case watchOS
    case Linux
}
