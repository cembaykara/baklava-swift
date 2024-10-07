//
//  RequestHandler.swift
//
//
//  Created by Baris Cem Baykara on 04.05.2024.
//

import Foundation
import Combine
import OSLog

/// Interceptor
public protocol Interceptor {
	
	/// Indicates how many times the request will be retried
	var retryCount: Int { get set }
	
	/// Indicates the dealy between retries
	var delayInterval: TimeInterval { get set }
	
	/// Adapts the request for retrying
	func adapt(request: URLRequest) async -> Result<URLRequest, Error>
}

@_spi(BKLInternal) public actor Session {
    
    public static var shared = Session()
    
    /// Auth token of the session
    private(set) public var authToken: String?
    
    /// Sets Auth Token
    public func setAuthToken(_ authToken: String?) {
        self.authToken = authToken
    }
	
	/// A convenience method to load data using `URLRequest`.
	///
	/// - Supports intercepting requests with a custom `Interceptor`.
    @discardableResult
    public static func performHttp(_ request: URLRequest, interceptor: Interceptor? = nil) async throws -> Data {
        let session = URLSession.shared
        
        let requestLogger = BKLLogger(subsystem: "BKL", category: "Network")
        
        return try await Task.retryable(maxRetryCount: interceptor?.retryCount ?? 0, retryDelay: interceptor?.delayInterval ?? 0) {
            var _request = request
            
            if let interceptor {
                do {
                    _request = try await interceptor.adapt(request: request).get()
                } catch {
                    requestLogger.log(
                        BKLLogEntry(
							verbosityLevel: .warning,
                            message: "Interceptor encountered a problem. Reason: " +  error.localizedDescription))
                }
            }
            
            requestLogger.log(
                BKLLogEntry(
                    verbosityLevel: .info,
                    message: "\(String(describing: _request.httpMethod)) \(_request.description)"))
            
            do {
                let (data, response) = try await session.data(for: _request)
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw RequestError.noResponse
                }
                
                guard (200...299).contains(httpResponse.statusCode) else {
                    throw RequestError.invalidStatusCode(httpResponse.statusCode, data)
                }
                
                return data
            } catch { throw error }
        }.value
    }
}

public enum RequestError: LocalizedError {
	case error(Error)
	case invalidStatusCode(Int, Data)
	case noResponse
}
