//
//  User.swift
//  BaklavaSDK
//
//  Created by Baris Cem Baykara on 23.09.2024.
//
import Foundation
import JWTDecode


/// Userthat is currently signed in
/// - Warning: Subject to heavy changes. This object will be served from the API and will not
/// be decoded from the JWT token.
/// The `JWTDecode` dependency will eventually be dropped.
public struct User {
    
    /// User ID
    var id: String
}

extension User {
    
    @_spi(BKLInternal) public init(_ token: String) throws {
        let jwt = try JWTDecode.decode(jwt: token) // TODO: - Wrap Error into a UserError
        guard jwt.expired == false else { throw UserError.expiredToken(token) }
        guard let subject = jwt.subject else { throw UserError.emptyTokenString }
        self.id = subject
        
        guard !id.isEmpty else { throw UserError.invalidToken(token) }
    }
    
    private enum Claim: String {
        case sub = "sub"
        case exp = "exp"
    }
}

public enum UserError: LocalizedError {
    case error(Error)
    case expiredToken(String)
    case invalidToken(String)
    case emptyTokenString
    
    public var errorDescription: String? {
        switch self {
            case .error(let error): error.localizedDescription
            case .expiredToken(let token): token
            case .invalidToken(let token): token
            case .emptyTokenString: "Token string is empty."
        }
    }
}
