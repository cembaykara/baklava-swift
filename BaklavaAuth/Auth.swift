//
//  Auth.swift
//  BaklavaSDK
//
//  Created by Baris Cem Baykara on 21.09.2024.
//

import Foundation
import Combine
@_spi(BKLInternal) import BaklavaCore

public actor Auth {

    /// Authentication token
    private(set) static public var authToken: String?
    
    private init() { }
}

// MARK: - Public Setters

extension Auth {
    
    /// Sets the auth token
    ///
    /// - Warning: Use this method **only** if you have set
    /// ```AuthConfiguration/preferKeychain``` configuration to `false` and token management is done manually.
    public static func setAuthToken(_ tokenString: String?) throws {
        // TODO: - Implement Keychain
        //precondition(true, "preferKeychain option must be disabled. Keychain is managed internally."
        try Auth._setAuthToken(tokenString)
    }
    
    /// Removes locally stored user data and signs out the user
    public static func signOut() {
        Auth._signOut()
    }
}

// MARK: - Public Interfaces

extension Auth {
    
    @discardableResult
    public static func login(with credentials: Credential) -> AnyPublisher<User,Error> {
        return Auth.authenticate(with: credentials as! PasswordLoginCredentials)
            .tryMap {
                try Auth.setAuthToken($0.authToken.token)
                return try User($0.authToken.token)
            }
            .catch { (error: Error) -> AnyPublisher<User,Error> in
                Auth.authToken = nil
                return Fail(error: error).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    @discardableResult
    public static func register(with credentials: Credential) -> AnyPublisher<Bool,Error> {
        return Auth.register(with: credentials as! PasswordLoginCredentials)
            .map(\.success)
            .eraseToAnyPublisher()
    }
}

// MARK: - Private Setters

extension Auth {
    
    /// Sets the ```authToken```
    ///
    /// - Postcondition: If ```AuthConfiguration/preferKeychain``` is `true` then the given `AuthToken` object will also be saved in to the keychain.
    private static func _setAuthToken(_ tokenString: String?) throws {
        // TODO: - Handle Keychain
        if let tokenString {
           let token = try AuthToken(tokenString)
        }
        Auth.authToken = tokenString
    }
    
    /// Clears all the tokens both in memory and in keychain
    private static func _signOut() {
        // TODO: - Handle Keychain
        Auth.authToken = nil
    }
}
