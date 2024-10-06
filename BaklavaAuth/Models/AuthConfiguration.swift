//
//  AuthConfiguration.swift
//  BaklavaSDK
//
//  Created by Baris Cem Baykara on 06.10.2024.
//

/// Auth Configuration
public struct AuthConfiguration {
	
	/// If `true`, authentication token will be persisted in the keychain and managed
	/// automatically. Default is `true`.
	///
	/// - Set this to `false` when you want to manually manage authentication token and client tokens.
	public var preferKeychain: Bool = true
}
