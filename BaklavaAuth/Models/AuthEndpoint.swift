//
//  AuthEndpoint.swift
//  BaklavaSDK
//
//  Created by Baris Cem Baykara on 21.09.2024.
//

@_spi(BKLInternal) import BaklavaCore
import SwiftyEndpoint

internal enum AuthEndpoint: SwiftyEndpoint {
    case password
    case register
    
    static var configuration: Baklava.Configuration { Baklava.getConfiguration() }
    
    static var basePath: String { "/auth" }
    
    var path: String {
        switch self {
            case .password: "/login"
            case .register: "/register"
        }
    }
}
