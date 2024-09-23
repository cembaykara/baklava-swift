//
//  Credentials.swift
//  BaklavaSDK
//
//  Created by Baris Cem Baykara on 21.09.2024.
//

import Foundation

public protocol Credential { }

/// Password credentials
public struct PasswordLoginCredentials: Encodable, Credential {
    
    /// Email of the user
    public let email: String
    
    /// Password of the user
    public let password: String
    
    internal let endpoint: AuthEndpoint
    
    private enum CodingKeys: CodingKey {  case email, password }
    
    /// Initializes a `PasswordLoginCredentials` object
    public init(email: String, password: String) {
        self.email = email
        self.password = password
        self.endpoint = .password
    }
}
