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
    internal static func authenticate(with credentials: PasswordLoginCredentials) -> AnyPublisher<AuthResponse,Error> {
        guard let url = credentials.endpoint.url() else {
            preconditionFailure("Encountered unexpected nil while making URL for \(AuthEndpoint.basePath)\n Path: \(credentials.endpoint.path)")
        }
        
        do {
            let bklRequest = try URLRequest.baklavaRequest(url: url, httpMethod: .post(credentials))
            return RequestHandler.execute(bklRequest)
                .map(\.data)
                .decode(type: AuthResponse.self, decoder: JSONDecoder())
                .eraseToAnyPublisher()
        } catch { return Fail(error: AuthServiceError.error(error)).eraseToAnyPublisher() }
    }
    
    internal static func register(with credentials: PasswordLoginCredentials) -> AnyPublisher<RegisterResponse,Error> {
        guard let url = AuthEndpoint.register.url() else {
            preconditionFailure("Encountered unexpected nil while making URL for \(AuthEndpoint.basePath)\n Path: \(AuthEndpoint.register.path)")
        }
        
        do {
            let bklRequest = try URLRequest.baklavaRequest(url: url, httpMethod: .post(credentials))
            return RequestHandler.execute(bklRequest)
                .map(\.data)
                .decode(type: RegisterResponse.self, decoder: JSONDecoder())
                .eraseToAnyPublisher()
        } catch { return Fail(error: AuthServiceError.error(error)).eraseToAnyPublisher() }
    }
}
