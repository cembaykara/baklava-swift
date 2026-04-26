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
    internal func authenticate(with credentials: PasswordCredentials) async throws -> AuthResponse {
        guard let url = credentials.endpoint.url() else {
            preconditionFailure("Encountered unexpected nil while making URL for \(AuthEndpoint.basePath)\n Path: \(credentials.endpoint.path)")
        }
        
        do {
            let request = try URLRequest.baklavaRequest(url: url, httpMethod: .post(credentials))
            return try await NetworkSession.performHttp(request).decode(as: AuthResponse.self)
        } catch { throw AuthError.error(error) }
    }
    
    internal func register(with credentials: PasswordCredentials) async throws -> RegisterResponse {
        guard let url = AuthEndpoint.register.url() else {
            preconditionFailure("Encountered unexpected nil while making URL for \(AuthEndpoint.basePath)\n Path: \(AuthEndpoint.register.path)")
        }
        
        do {
            let request = try URLRequest.baklavaRequest(url: url, httpMethod: .post(credentials))
            return try await NetworkSession.performHttp(request).decode(as: RegisterResponse.self)
        } catch { throw AuthError.error(error) }
    }
}
