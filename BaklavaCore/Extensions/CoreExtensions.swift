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
    ///
    /// - Warning: This will be internal. Call from `BaklavaService`.
    ///
    /// # Example:
    ///
    /// ```swift
    /// ...
    /// var flags: [Flag] = []
    ///
    ///private var cancellable = Set<AnyCancellable>()
    ///private let service = Service(Flag.self)
    ///
    ///func fetchFlags() {
    ///    service.getFlags()
    ///        .sink { print($0) } receiveValue: { self.flags = $0 }
    ///        .store(in: &cancellable)
    ///}
    ///...
    /// ```
    ///
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
