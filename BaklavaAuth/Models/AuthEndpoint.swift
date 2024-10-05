//
//  AuthEndpoint.swift
//  BaklavaSDK
//
//  Created by Baris Cem Baykara on 21.09.2024.
//

@_spi(BKLInternal) import BaklavaCore

internal enum AuthEndpoint: Endpoint {
    case password
    case register
    
    static var basePath: String { "/auth" }
    
    var path: String {
        switch self {
            case .password: "/login"
            case .register: "/register"
        }
    }
}
