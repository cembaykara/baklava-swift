//
//  FFLogEntry.swift
//
//
//  Created by Baris Cem Baykara on 04.05.2024.
//

import Foundation

public struct FFLogEntry {
	
	/// The `OSLog` subsystem
	public var subSystem: String
	
	///  The `OSLog` category
	public var category: String
	
	///  The `OSLog` verbosity
	public var verbosityLevel: LogVerbosityLevel
	
	/// Message to be logged to the `OSLog`
	public var message: String
	
	public init(subSystem: String, category: String, verbosityLevel: LogVerbosityLevel, message: String) {
		self.subSystem = subSystem
		self.category = category
		self.verbosityLevel = verbosityLevel
		self.message = message
	}
}
