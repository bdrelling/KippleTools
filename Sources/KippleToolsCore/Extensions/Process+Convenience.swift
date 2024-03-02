import Foundation

public extension Process {
    convenience init (
        executablePath: String,
        arguments: [String]? = nil,
        environment: [String: String]? = nil,
        workingDirectory: String? = nil
    ) {
        self.init()
        
        // Set the executable path for the process.
        self.executableURL = URL(fileURLWithPath: executablePath)

        // Set arguments for the process.
        self.arguments = arguments

        // Load environment variables into the process.
        self.environment = environment

        // Set the working directory for the process.
        if let workingDirectory = workingDirectory {
            self.currentDirectoryURL = URL(fileURLWithPath: workingDirectory, isDirectory: true)
        }
    }
    
    @discardableResult
    func run(outputPipe: Pipe) throws -> String {
        // Set the pipe for stdout
        self.standardOutput = outputPipe
        
        // Run the process.
        try self.run()

        // Create variables for our stdout and stderr data.
        let outputData: Data

        // Read the stdout, and stderr data.
        outputData = try outputPipe.fileHandleForReading.readToEnd() ?? Data()

        // Convert data to strings.
        let output = String(data: outputData, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines)

        // If there's no output, throw an error
        // Successful commands should still return empty output, so treat this as a command failure as well
        guard let unwrappedOutput = output else {
            throw ProcessError.outputNotFound
        }

        return unwrappedOutput
    }
}

// MARK: - Supporting Types

public enum ProcessError: LocalizedError {
    case outputNotFound
    
    public var errorDescription: String? {
        switch self {
        case .outputNotFound: "Process output not found."
        }
    }
}
