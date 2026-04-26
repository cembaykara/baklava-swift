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
public final actor Auth {
    public static let shared = Auth()
    
    private let context = AuthContext()
    private init() {}
    
    // MARK: - Compatibility static API
    public static func setConfiguration(_ configuration: AuthConfiguration) {
        Task { await Auth.shared.setConfiguration(configuration) }
    }
    
    public static func setAuthToken(_ tokenString: String?) async {
        let config = await Auth.shared.getConfiguration()
        precondition(
            !config.preferKeychain,
            "Keychain is managed internally. preferKeychain option must be disabled."
        )
        await Auth.shared.setAccessToken(tokenString)
    }
    
    public static func getAuthToken() async -> String? {
        await Auth.shared.getAccessToken()
    }
    
    public static func clearAuthState() {
        Task { await Auth.shared.clearAuthState() }
    }
    
    @discardableResult
    public static func login(with credentials: Credential) async throws -> User {
        try await Auth.shared.login(with: credentials)
    }
    
    @discardableResult
    public static func register(with credentials: Credential) async throws -> RegisterResponse {
        try await Auth.shared.register(with: credentials)
    }
}

// MARK: - Public API
public extension Auth {
    func setConfiguration(_ configuration: AuthConfiguration) async {
        await context.setConfiguration(configuration)
    }
    
    func getConfiguration() async -> AuthConfiguration {
        await context.getConfiguration()
    }
    
    func setAccessToken(_ accessToken: String?) async {
        await context.setAccessToken(accessToken)
    }
    
    func getAccessToken() async -> String? {
        await context.getAccessToken()
    }
    
    @discardableResult
    func login(with credentials: Credential) async throws -> User {
        guard let passwordCredentials = credentials as? PasswordCredentials else {
            throw AuthError.unsupportedCredentials
        }
        
        do {
            let authResponse = try await authenticate(with: passwordCredentials)
            await setAccessToken(authResponse.authToken.token)
            return try User(authResponse.authToken.token)
        } catch {
            await setAccessToken(nil)
            throw AuthError.error(error)
        }
    }
    
    @discardableResult
    func register(with credentials: Credential) async throws -> RegisterResponse {
        guard let passwordCredentials = credentials as? PasswordCredentials else {
            throw AuthError.unsupportedCredentials
        }
        return try await register(with: passwordCredentials)
    }
    
    func clearAuthState() async {
        await setAccessToken(nil)
        SecureStorage.remove(forKey: AuthKeys.authToken)
    }
}
