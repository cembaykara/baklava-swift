//
//  File.swift
//  
//
//  Created by Baris Cem Baykara on 04.05.2024.
//

import Foundation
import Combine
@_spi(BKLInternal) import BaklavaCore

// TODO: Add better error handling
// TODO: Log errors better

public extension Service where Entity: FeatureFlag {
	
	func getFlags() -> AnyPublisher<[Entity], Error> {
		guard let url = FeatureFlagEndpoint.baseURL() else {
			return Fail(error: ServiceError.urlError())
				.eraseToAnyPublisher()
		}
		
		do {
			let request = try URLRequest.baklavaRequest(url: url, httpMethod: .get)
			
			return RequestHandler.execute(request)
				.map(\.data)
				.decode(type: [Entity].self, decoder: JSONDecoder())
				.eraseToAnyPublisher()
		} catch { return Fail(error: ServiceError.error(error)).eraseToAnyPublisher() }
	}
	
	@discardableResult
	func deleteBy(id: UUID) -> AnyPublisher<URLResponse, Error> {
		guard let url = FeatureFlagEndpoint.delete(id: id).url() else {
			return Fail(error: ServiceError.urlError())
				.eraseToAnyPublisher()
		}
		
		do {
			let request = try URLRequest.baklavaRequest(url: url, httpMethod: .delete)
			
			return RequestHandler.execute(request)
				.map(\.response)
				.eraseToAnyPublisher()
		} catch { return Fail(error: ServiceError.error(error)).eraseToAnyPublisher() }
	}
	
	@discardableResult
	func createNew(object: Entity) -> AnyPublisher<Entity, Error> {
		guard let url = FeatureFlagEndpoint.baseURL() else {
			return Fail(error: ServiceError.urlError())
				.eraseToAnyPublisher()
		}
		
		do {
			let request = try URLRequest.baklavaRequest(url: url, httpMethod: .post(object))
			
			return RequestHandler.execute(request)
				.map(\.data)
				.decode(type: Entity.self, decoder: JSONDecoder())
				.eraseToAnyPublisher()
		} catch { return Fail(error: ServiceError.error(error)).eraseToAnyPublisher() }
	}
	
	@discardableResult
	func update(_ object: Entity) -> AnyPublisher<URLResponse, Error> {
		guard let id = object.id else {
			return Fail(error: ServiceError.urlError())
				.eraseToAnyPublisher()
		}
		
		guard let url = FeatureFlagEndpoint.update(id: id).url() else {
			return Fail(error: ServiceError.urlError())
				.eraseToAnyPublisher()
		}
		
		do {
			let request = try URLRequest.baklavaRequest(url: url, httpMethod: .put(object))
			
			return RequestHandler.execute(request)
				.map(\.response)
				.eraseToAnyPublisher()
		} catch { return Fail(error: ServiceError.error(error)).eraseToAnyPublisher() }
	}
}

