//
//  AuthToken.swift
//  BaklavaSDK
//
//  Created by Baris Cem Baykara on 21.09.2024.
//

@_spi(BKLInternal) import BaklavaCore

/// A wrapper object that represents an `AuthToken`.
internal struct AuthToken: JWTToken, Equatable {
    
    /// String that represents an authToken.
    internal let token: String
    
    /// Initializes an `AuthToken`object.
    internal init(_ token: String) throws {
        self.token = token
        
        if !self.isValid {
            throw AuthError.expiredToken(token)
        }
    }
}

extension AuthToken: Codable {
    /// A convenience property to get a ```User``` object
    internal var user: User {
        get throws { return try User(token) }
    }
    
    private enum CodingKeys: String, CodingKey {
        case token = "authToken"
    }
}
