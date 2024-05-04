//
//  LogVerbosityLevel.swift
//
//
//  Created by Baris Cem Baykara on 04.05.2024.
//

import Foundation

/// Enum representing the verbosity levels for logging.
public enum LogVerbosityLevel: Comparable {
	
	/// Log Verbosity none
	case none
	
	/// Log Verbosity notice
	case notice
	
	///Log Verbosity info
	case info
	
	/// Log Verbosity debug
	case debug
	
	/// Log Verbosity trace
	case trace
	
	/// Log Verbosity warning
	case warning
	
	/// Log Verbosity error
	case error
	
	/// Log Verbosity fault
	case fault
	
	/// Log Verbosity critical
	case critical
}
