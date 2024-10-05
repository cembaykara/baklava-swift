//
//  CoreExtensions.swift
//
//
//  Created by Baris Cem Baykara on 17.05.2024.
//

import Foundation

// MARK: - URLRequest
@_spi(BKLInternal)
public extension URLRequest {
	
    /// Builds a `URLRequest`object for a `BaklavaService` request.
	static func baklavaRequest(url: URL, httpMethod: HTTPMethod) throws -> URLRequest {
		var request = URLRequest(url: url)
		
		switch httpMethod {
			case .put(let body), .post(let body), .patch(let body):
				request.setValue("application/json", forHTTPHeaderField: "Content-Type")
				if let body { request.httpBody = try JSONEncoder().encode(body) }
			default: break
		}
		
		request.httpMethod = httpMethod.description
		return request
	}
}

// MARK: - Data

@_spi(BKLInternal) public extension Data {
    
    /// A convenience method to decode data to a `Decodable` with a `JSONDecoder`.
    func decode<T>(as object: T.Type, withDecoder decoder: JSONDecoder = .init()) async throws -> T where T: Decodable {
        do {
            let jsonObject = try decoder.decode(T.self, from: self)
            return jsonObject
        } catch { throw error }
    }
}

// MARK: - Task

@_spi(BKLInternal) public extension Task where Failure == Error {
    @discardableResult
    static func retryable(
        maxRetryCount: Int = 0,
        retryDelay: TimeInterval = 0,
        operation: @Sendable @escaping () async throws -> Success) -> Task {
            Task {
                for _ in 0..<maxRetryCount {
                    do { return try await operation() }
                    catch {
                        let delay = UInt64(1_000_000_000 * retryDelay)
                        try await Task<Never, Never>.sleep(nanoseconds: delay)
                        
                        continue
                    }
                }
                
                try Task<Never, Never>.checkCancellation()
                return try await operation()
            }
        }
}
