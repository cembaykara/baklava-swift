//
//  FeatureFlagsInterceptor.swift
//  BaklavaSDK
//
//  Created by Baris Cem Baykara on 26.09.2024.
//

import Foundation
@_spi(BKLInternal) import BaklavaCore

internal struct FeatureFlagsInterceptor: Interceptor {
    var retryCount: Int = 2  {
        didSet {
            precondition(retryCount >= 0, "Retry count must be non-negative")
        }
    }
    
    var delayInterval: TimeInterval = 2 {
        didSet {
            precondition(delayInterval >= 0, "Delay interval must be non-negative")
        }
    }
    
    func adapt(request: URLRequest) async -> Result<URLRequest, any Error> {
        var _request = request
        
        // If auth token doesn't exist, do not bother with the session token
		// TODO: - Implement token refresh
		
        if await Session.shared.authToken == nil {
            return .failure(ServiceError.invalidAuthToken("No auth token found"))
        }
        
        
        if let authToken = await Session.shared.authToken  {
            _request.setValue("bearer \(authToken)", forHTTPHeaderField: "Authorization")
            return .success(_request)
        }
        
        return .failure(ServiceError.invalidAuthToken("No auth token found"))
    }
}
