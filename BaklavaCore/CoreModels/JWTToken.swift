//
//  JWTToken.swift
//  BaklavaSDK
//
//  Created by Baris Cem Baykara on 21.09.2024.
//

import Foundation
import JWTDecode

@_spi(BKLInternal) public protocol JWTToken {
    
    var token: String { get }
}

public extension JWTToken {
    
    var isValid: Bool {
        guard let jwt = try? decode(jwt: token) else { return false }
        return !jwt.expired
    }
}
