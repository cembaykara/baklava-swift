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
	
	let port: Int?
	
	public init(logVerbosity: LogVerbosityLevel = .critical, host: String? = nil, port: Int? = nil) {
		self.logVerbosity = logVerbosity
		self.host = host
		self.port = port
	}
	
}
