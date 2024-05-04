//
//  File.swift
//  
//
//  Created by Baris Cem Baykara on 04.05.2024.
//

import Foundation
import Combine
import BaklavaCore

// TODO: Implement a request builder
// TODO: Implement an Endpoint builder
// TODO: Add better error handling
// TODO: Log errors better

public extension Service where Entity: FeatureFlag {
	
	func getFlags() -> AnyPublisher<[Entity], Error> {
		guard let url = URL(string: "http://127.0.0.1:8080/flags") else {
			return Fail(error: ServiceError.urlError())
				.eraseToAnyPublisher()
		}
		
		var request = URLRequest(url: url)
		request.httpMethod = "GET"
		
		return RequestHandler.execute(request)
			.map(\.data)
			.decode(type: [Entity].self, decoder: JSONDecoder())
			.eraseToAnyPublisher()
	}
	
	@discardableResult
	func deleteBy(id: UUID) -> AnyPublisher<URLResponse, Error> {
		guard let url = URL(string: "http://127.0.0.1:8080/flags/\(id.uuidString)") else {
			return Fail(error: ServiceError.urlError())
				.eraseToAnyPublisher()
		}
		
		var request = URLRequest(url: url)
		request.httpMethod = "DELETE"
		
		return RequestHandler.execute(request)
			.map(\.response)
			.eraseToAnyPublisher()
	}
	
	@discardableResult
	func createNew(object: Entity) -> AnyPublisher<Entity, Error> {
		guard let url = URL(string: "http://127.0.0.1:8080/flags") else {
			return Fail(error: ServiceError.urlError())
				.eraseToAnyPublisher()
		}
		
		guard let payload = try? JSONEncoder().encode(object) else {
			return Fail(error: ServiceError.urlError()) // TODO: Implement appropriate error logging
				.eraseToAnyPublisher()
		}
		
		var request = URLRequest(url: url)
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		request.httpMethod = "POST"
		request.httpBody = payload
		
		return RequestHandler.execute(request)
			.map(\.data)
			.decode(type: Entity.self, decoder: JSONDecoder())
			.eraseToAnyPublisher()
	}
	
	@discardableResult
	func update(_ object: Entity) -> AnyPublisher<Entity, Error> {
		guard let id = object.id else {
			return Fail(error: ServiceError.urlError())
				.eraseToAnyPublisher()
		}
		
		guard let url = URL(string: "http://127.0.0.1:8080/flags/\(id.uuidString)") else {
			return Fail(error: ServiceError.urlError())
				.eraseToAnyPublisher()
		}
		
		guard let payload = try? JSONEncoder().encode(object) else {
			return Fail(error: ServiceError.urlError())
				.eraseToAnyPublisher()
		}
		
		var request = URLRequest(url: url)
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		request.httpMethod = "PUT"
		request.httpBody = payload
		
		return RequestHandler.execute(request)
			.map(\.data)
			.decode(type: Entity.self, decoder: JSONDecoder())
			.eraseToAnyPublisher()
	}
}

