//
//  BKLLogEntry.swift
//
//
//  Created by Baris Cem Baykara on 04.05.2024.
//

import Foundation

public struct BKLLogEntry {

	///  The `OSLog` verbosity
	public var verbosityLevel: LogVerbosityLevel
	
	/// Message to be logged to the `OSLog`
	public var message: String
	
	public init(verbosityLevel: LogVerbosityLevel, message: String) {
		self.verbosityLevel = verbosityLevel
		self.message = message
	}
}
