import Foundation

public struct Shell {
    private let executablePath: String
    private let outputPipe: Pipe
    
    private init(
        executablePath: String,
        outputPipe: Pipe = .init()
    ) {
        self.executablePath = executablePath
        self.outputPipe = outputPipe
    }
    
    @discardableResult
    public func callAsFunction(
        _ command: String,
        environment: [String: String]? = nil,
        workingDirectory: String? = nil
    ) throws -> String {
        let process = Process(
            executablePath: self.executablePath,
            arguments: ["-c", command],
            environment: environment,
            workingDirectory: workingDirectory
        )
        
        return try process.run(outputPipe: self.outputPipe)
    }
}

// MARK: - Convenience

public extension Shell {
    static let `default`: Self = .bash
    
    static let sh: Self = .init(executablePath: "/bin/sh")
    static let bash: Self = .init(executablePath: "/bin/bash")
    static let zsh: Self = .init(executablePath: "/bin/zsh")
}
