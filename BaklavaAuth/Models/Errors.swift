//
//  Errors.swift
//  BaklavaSDK
//
//  Created by Baris Cem Baykara on 21.09.2024.
//

import Foundation

public enum AuthError: LocalizedError {
    case error(Error)
    case expiredToken(String)
    case invalidToken(String)
    
    public var errorDescription: String? {
        switch self {
            case .error(let error): error.localizedDescription
            case .expiredToken(let token): token
            case .invalidToken(let token): token
        }
    }
}

public enum AuthServiceError: LocalizedError {
    case error(Error)
    case encodingFailed
    
    public var errorDescription: String? {
        switch self {
            case .error(let error): error.localizedDescription
            case .encodingFailed: "Encoding Failed"
        }
    }
}
