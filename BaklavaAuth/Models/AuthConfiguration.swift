//
//  AuthConfiguration.swift
//  BaklavaSDK
//
//  Created by Baris Cem Baykara on 06.10.2024.
//

import Foundation
@_spi(BKLInternal) import BaklavaCore

/// Auth Configuration
public struct AuthConfiguration: Sendable {
	
	/// If `true`, authentication token will be persisted in the keychain and managed
	/// automatically. Default is `true`.
	///
	/// - Set this to `false` when you want to manually manage authentication token and client tokens.
	public let preferKeychain: Bool
    
    /// Interceptor used for authenticated requests.
    public let interceptor: any Interceptor
    
    @_spi(BKLInternal) public init(preferKeychain: Bool = true) {
        self.preferKeychain = preferKeychain
        self.interceptor = BKLInterceptor()
    }
    
    public init(preferKeychain: Bool = true, interceptor: (any Interceptor)? = nil) {
        self.preferKeychain = preferKeychain
        self.interceptor = interceptor ?? BKLInterceptor()
    }
}
