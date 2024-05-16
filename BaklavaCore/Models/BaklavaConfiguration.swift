//
//  BaklavaConfiguration.swift
//
//
//  Created by Baris Cem Baykara on 04.05.2024.
//

import Foundation

public struct BaklavaConfiguration {
	
	private(set) var logVerbosity: LogVerbosityLevel
	
	let host: String?
	
	init(logVerbosity: LogVerbosityLevel = .critical, host: String? = nil) {
		self.logVerbosity = logVerbosity
		self.host = host
	}
	
}
