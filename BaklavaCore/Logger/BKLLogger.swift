//
//  BKLLogger.swift
//
//
//  Created by Baris Cem Baykara on 04.05.2024.
//

import Foundation
import OSLog

@_spi(BKLInternal) public class BKLLogger {
    
    private let logger: Logger
    
    public init(subsystem: String, category: String) {
        self.logger = Logger(subsystem: subsystem, category: category)
    }
	
	/// Writes a message to the `OSLog` based on the configured log verbosity level.
	public func log(_ entry: BKLLogEntry) {
		if entry.verbosityLevel <= Baklava.configuration.logVerbosity {
			switch entry.verbosityLevel {
				case .none:
					return
				case .notice:
					logger.notice("\(entry.message)")
				case .info:
					logger.info("\(entry.message, privacy: .private)")
				case .debug:
					logger.debug("\(entry.message)")
				case .trace:
					logger.trace("\(entry.message)")
				case .warning:
					logger.warning("\(entry.message, privacy: .private(mask: .hash))")
				case .error:
					logger.error("\(entry.message)")
				case .fault:
					logger.fault("\(entry.message)")
				case .critical:
					logger.critical("\(entry.message)")
			}
		}
	}
	
	/// Logs any object to console
	public func consoleLog<T: Any>(_ object: T) {
		print(object)
	}
	
	/// Logs a message and an object to console
	public func consoleLog<T: Any>(_ string: String, _ object: T) {
		print(string, object)
	}
	
	/// Logs a Data object as JSON to the console
	public func consoleLogJSON(data: Data) throws {
		let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
		print(json)
	}
}
