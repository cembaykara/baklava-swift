//
//  AuthService.swift
//  BaklavaSDK
//
//  Created by Baris Cem Baykara on 21.09.2024.
//

import Foundation
import Combine
@_spi(BKLInternal) import BaklavaCore

extension Auth {
    
    /// Authenticate with `PasswordLoginCredentials`
    internal static func authenticate(with credentials: PasswordLoginCredentials) async throws -> AuthResponse {
        guard let url = credentials.endpoint.url() else {
            preconditionFailure("Encountered unexpected nil while making URL for \(AuthEndpoint.basePath)\n Path: \(credentials.endpoint.path)")
        }
        
        do {
            let bklRequest = try URLRequest.baklavaRequest(url: url, httpMethod: .post(credentials))
            return try await Session.performHttp(bklRequest).decode(as: AuthResponse.self)
        } catch { throw AuthError.error(error) }
    }
    
    internal static func register(with credentials: PasswordLoginCredentials) async throws -> RegisterResponse {
        guard let url = AuthEndpoint.register.url() else {
            preconditionFailure("Encountered unexpected nil while making URL for \(AuthEndpoint.basePath)\n Path: \(AuthEndpoint.register.path)")
        }
        
        do {
            let bklRequest = try URLRequest.baklavaRequest(url: url, httpMethod: .post(credentials))
            return try await Session.performHttp(bklRequest).decode(as: RegisterResponse.self)
        } catch { throw AuthError.error(error) }
    }
}
