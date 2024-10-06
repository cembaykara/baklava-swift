//
//  Auth.swift
//  BaklavaSDK
//
//  Created by Baris Cem Baykara on 21.09.2024.
//

import Foundation
import Combine
@_spi(BKLInternal) import BaklavaCore

/// An object to handle Baklava Auth Services
public struct Auth {
	
	/// Configuration for `Auth` behaviour.
	private(set) static var configuration: AuthConfiguration = .init()
    
    private init() { }
}

// MARK: - Public Setters

extension Auth {
    
	/// Sets auth configuration.
	public static func setConfiguration(_ configuration: AuthConfiguration) {
		Auth.configuration = configuration
	}
	
    /// Sets the auth token
    ///
    /// - Warning: Use this method **only** if you have set
    /// ```AuthConfiguration/preferKeychain``` configuration to `false` and token management is done manually.
    public static func setAuthToken(_ tokenString: String?) async throws {
		precondition(
			Auth.configuration.preferKeychain,
			"preferKeychain option must be disabled. Keychain is managed internally."
		)
        do { try await Auth._setAuthToken(tokenString) }
		catch { throw error }
    }
    
    /// Gets the auth token
    public static func getAuthToken() async -> String? {
        return await Auth._getAuthToken()
    }
    
    /// Removes locally stored user data and signs out the user
    public static func signOut() {
        Auth._signOut()
    }
}

// MARK: - Public Interfaces

extension Auth {
    
	/// Login to Baklava
    @discardableResult
    public static func login(with credentials: Credential) async throws -> User {
        do {
            let authResponse = try await Auth.authenticate(with: credentials as! PasswordLoginCredentials)
            try await Auth._setAuthToken(authResponse.authToken.token)
            return try User(authResponse.authToken.token)
        } catch {
            try? await Auth._setAuthToken(nil)
            throw AuthError.error(error)
        }
    }
    
	/// Register with Baklava
    @discardableResult
    public static func register(with credentials: Credential) async throws -> RegisterResponse {
        return try await Auth.register(with: credentials as! PasswordLoginCredentials)
    }
    
    public static func fetchSessionToken() async throws { }
}

// MARK: - Private Setters

extension Auth {
    
    /// Sets the ```authToken```
    ///
    /// - Postcondition: If ```AuthConfiguration/preferKeychain``` is `true`,
    /// then the given token will also be saved in to the keychain.
    private static func _setAuthToken(_ tokenString: String?) async throws {
		
		if Auth.configuration.preferKeychain {
			// TODO: - Handle Keychain
		}
		
        
        do {
            if let tokenString {  let _ = try AuthToken(tokenString) }
            await Session.shared.setAuthToken(tokenString)
        } catch { throw AuthError.error(error) }
    }
    
    /// Gets the ```authToken```
    private static func _getAuthToken() async -> String? {
        return await Session.shared.authToken
    }
    
    /// Clears all the tokens both in memory and in keychain
    private static func _signOut() {
        Task {  await Session.shared.setAuthToken(nil) }
    }
}
