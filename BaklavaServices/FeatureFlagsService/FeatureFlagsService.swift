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
	
	/// Fetches all flags avaialable to the user.
	func getFlags() async throws -> [Entity] {
		guard let url = FeatureFlagEndpoint.baseURL() else {
			throw ServiceError.urlError()
		}
		
		do {
			let request = try URLRequest.baklavaRequest(url: url, httpMethod: .get)
			
            let response = try await NetworkSession.performHttp(request, interceptor: interceptor).decode(as: PageResponse<Entity>.self)
			return response.data
		} catch { throw ServiceError.error(error) }
	}
	
	/// Sends a `DELETE` request for a flag with given id.
	@discardableResult
	func deleteBy(id: UUID) async throws -> Bool {
		guard let url = FeatureFlagEndpoint.delete(id: id).url() else {
			throw ServiceError.urlError()
		}
		
		do {
			let request = try URLRequest.baklavaRequest(url: url, httpMethod: .delete)
			try await NetworkSession.performHttp(request, interceptor: interceptor)
			
			return true
		} catch { throw ServiceError.error(error) }
	}
	
	/// Creates a new feature flag object.
	@discardableResult
	func createNew(object: Entity) async throws -> Entity {
		guard let url = FeatureFlagEndpoint.baseURL() else {
			throw ServiceError.urlError()
		}
		
		do {
			let request = try URLRequest.baklavaRequest(url: url, httpMethod: .post(object))
			
            let response = try await NetworkSession.performHttp(request, interceptor: interceptor).decode(as: Response<Entity>.self)
			return response.data
		} catch { throw ServiceError.error(error) }
	}
	
	/// Updates a flag object.
	@discardableResult
	func update(_ object: Entity) async throws -> Bool {
		guard let id = object.id else {
			throw ServiceError.urlError()
		}
		
		guard let url = FeatureFlagEndpoint.update(id: id).url() else {
			throw ServiceError.urlError()
		}
		
		do {
			let request = try URLRequest.baklavaRequest(url: url, httpMethod: .put(object))
			try await NetworkSession.performHttp(request, interceptor: interceptor)
			
			return true
		} catch { throw ServiceError.error(error) }
	}
}
