//
//  AuthResponse.swift
//  BaklavaSDK
//
//  Created by Baris Cem Baykara on 21.09.2024.
//
import Foundation

/// Authentication Response Object
internal struct AuthResponse: Decodable {
    
	/// The wrapped `AuthToken`
	internal let authToken: AuthToken
    
    init (from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let authTokenString = try container.decode(String.self, forKey: .authToken)
        self.authToken = try AuthToken(authTokenString)
    }
}

extension AuthResponse {
    
	enum CodingKeys: String, CodingKey {
        case authToken
    }
}
