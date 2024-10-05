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
    
    /// Username of the user
    public let username: String
    
    /// Password of the user
    public let password: String
    
    internal let endpoint: AuthEndpoint
    
    private enum CodingKeys: CodingKey {  case username, password }
    
    /// Initializes a `PasswordLoginCredentials` object
    public init(username: String, password: String) {
        self.username = username
        self.password = password
        self.endpoint = .password
    }
}
