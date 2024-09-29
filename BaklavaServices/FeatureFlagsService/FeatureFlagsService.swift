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
	
    /// 
    func getFlags() async throws -> [Entity] {
		
        guard let url = FeatureFlagEndpoint.baseURL() else {
			throw ServiceError.urlError()
		}
		
		do {
			let request = try URLRequest.baklavaRequest(url: url, httpMethod: .get)
			
            return try await Session.performHttp(request).decode(as: [Entity].self)
        } catch { throw ServiceError.error(error) }
	}
	
	@discardableResult
    func deleteBy(id: UUID) async throws -> Bool {
		guard let url = FeatureFlagEndpoint.delete(id: id).url() else {
			throw ServiceError.urlError()
		}
		
		do {
			let request = try URLRequest.baklavaRequest(url: url, httpMethod: .delete)
			
            try await Session.performHttp(request)
            return true
		} catch { throw ServiceError.error(error) }
	}
	
	@discardableResult
    func createNew(object: Entity) async throws -> Entity {
		guard let url = FeatureFlagEndpoint.baseURL() else {
            throw ServiceError.urlError()
		}
		
		do {
			let request = try URLRequest.baklavaRequest(url: url, httpMethod: .post(object))
			
            return try await Session.performHttp(request).decode(as: Entity.self)
		} catch { throw ServiceError.error(error) }
	}
	
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
			
			try await Session.performHttp(request)
            return true
		} catch { throw ServiceError.error(error) }
	}
}

