//
//  CoreExtensions.swift
//
//
//  Created by Baris Cem Baykara on 17.05.2024.
//

import Foundation

// MARK: - URLRequest

public extension URLRequest {
	
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
