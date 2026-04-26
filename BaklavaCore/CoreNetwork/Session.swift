//
//  RequestHandler.swift
//
//
//  Created by Baris Cem Baykara on 04.05.2024.
//

import Foundation
import Combine
import OSLog

@_spi(BKLInternal) public actor NetworkSession {
    public static let urlSession: URLSession = .shared
	
	/// A convenience method to load data using `URLRequest`.
	///
	/// - Supports intercepting requests with a custom `Interceptor`.
    @discardableResult
    public static func performHttp(_ request: URLRequest, interceptor: Interceptor? = nil) async throws -> Data {
        let requestLogger = BKLLogger(subsystem: "BKL", category: "Network")
        
        return try await Task.retryable(maxRetryCount: interceptor?.retryCount ?? 0, retryDelay: interceptor?.delayInterval ?? 0) {
            var _request = request
            
            if let interceptor {
                _request = await interceptor.adapt(request: request)
            }
            
            requestLogger.log(
                BKLLogEntry(
                    verbosityLevel: .info,
                    message: "\(String(describing: _request.httpMethod)) \(_request.description)"))
            
            do {
                let (data, response) = try await urlSession.data(for: _request)
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw RequestError.noResponse
                }
                
                guard (200...299).contains(httpResponse.statusCode) else {
                    if let interceptor {
                        await interceptor.retry(request: _request, response: httpResponse)
                    }
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
	
	public var errorDescription: String? {
		switch self {
			case .error(let error): error.localizedDescription
			case .invalidStatusCode(let code, let data): "Error Code: \(code)\n\(decodedError(from: data))"
			case .noResponse: "No Response"
		}
	}
    
    private func decodedError(from data: Data) -> String {
        guard let string = String(data: data, encoding: .utf8) else {
            return "Unable to decode server response"
        }
        
        if let json = try? JSONSerialization.jsonObject(with: data),
           let prettyData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
           let prettyString = String(data: prettyData, encoding: .utf8) {
            return prettyString
        }
        
        return string
    }
}
