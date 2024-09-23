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
	func adapt(request: URLRequest) -> Result<URLRequest, Error>
}

public struct RequestHandler {
	
	/// A convenience method to load data using `URLRequest`.
	///
	/// - Supports intercepting requests with a custom `Interceptor`.
	@discardableResult
	public static func execute(_ request: URLRequest, interceptor: Interceptor? = nil) -> AnyPublisher<URLSession.DataTaskPublisher.Output, Error> {
		
        var requestLogger = BKLLogger(subsystem: "BKL", category: "Network")
        
		let session = URLSession.shared
		var _request = request
		
		if let interceptor = interceptor {
			do {
				_request = try interceptor.adapt(request: request).get()
			} catch {
                requestLogger.log(
                    BKLLogEntry(
                        verbosityLevel: .error,
                        message: error.localizedDescription))
			}
		}
        
        requestLogger.log(
            BKLLogEntry(
                verbosityLevel: .debug,
                message: "Request: \(_request.description)"))
		
		return session.dataTaskPublisher(for: _request)
			.tryMap { dataTaskOutput -> Result<URLSession.DataTaskPublisher.Output, Error> in
				guard let httpResponse = dataTaskOutput.response as? HTTPURLResponse else {
					throw RequestError.noResponse
				}
				
				guard (200...299).contains(httpResponse.statusCode) else {
					throw RequestError.invalidStatusCode(httpResponse.statusCode, dataTaskOutput.data)
				}
				return .success(dataTaskOutput)
			}
			.catch { (error: Error) -> AnyPublisher<Result<URLSession.DataTaskPublisher.Output, Error>, Error> in
				switch error {
						
						/// Retry when these types of errors are thrown
					case RequestError.noResponse, RequestError.invalidStatusCode(_,_):
                        requestLogger.log(
                            BKLLogEntry(
                                verbosityLevel: .error,
                                message: error.localizedDescription))
						return Fail(error: error)
							.delay(for: .seconds(interceptor?.delayInterval ?? 0), scheduler: DispatchQueue.main)
							.eraseToAnyPublisher()
						
						/// Do NOT retry and emit a `.failure()` to upstream
					default:
						return Just(.failure(error))
							.setFailureType(to: Error.self)
							.eraseToAnyPublisher()
				}
			}
			.retry(interceptor?.retryCount ?? 0)
			.eraseToAnyPublisher()
			.tryMap { try $0.get() }
			.eraseToAnyPublisher()
	}
}

public enum RequestError: LocalizedError {
	case error(Error)
	case invalidStatusCode(Int, Data)
	case noResponse
}
