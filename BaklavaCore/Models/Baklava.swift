//
//  FFSDK.swift
//
//
//  Created by Baris Cem Baykara on 04.05.2024.
//

import Foundation
import SwiftyEndpoint

public struct Baklava {
	
	private(set) static var configuration = Configuration()
	
	public static func setConfiguration(_ configuration: Configuration) {
		Baklava.configuration = configuration
	}
    
    public static func getConfiguration() -> Configuration {
        configuration
    }
}

public extension Baklava {
    struct Configuration: SwiftyConfiguration {
        private(set) var logVerbosity: LogVerbosityLevel
        
        public let host: String?
        public let port: Int?
        public let disableSecureConnection: Bool
        
        public init(
            logVerbosity: LogVerbosityLevel = .critical,
            host: String? = nil,
            port: Int? = nil,
            disableSecureConnection: Bool = true
        ) {
            self.logVerbosity = logVerbosity
            self.host = host
            self.port = port
            self.disableSecureConnection = disableSecureConnection
        }
    }
}
