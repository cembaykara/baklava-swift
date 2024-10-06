//
//  File.swift
//  
//
//  Created by Baris Cem Baykara on 04.05.2024.
//

import Foundation
import BaklavaCore

/// A Service that interracts with the Baklava API.
///
/// This can be initialized with an Entity.
///
/// # Example:
///
/// ```swift
/// ...
/// var flags: [Flag] = []
///
///
///private let service = Service(Flag.self)
///
///func fetchFlags() async throws {
///    flags = try await service.getFlags()
///}
///...
/// ```
///
/// The Service object can only be initialized with an Entity type
/// and will change it's behaviour based on the entity.
public struct Service<Entity> where Entity: EntityProtocol & Codable {
	
	public init (_ type: Entity.Type) { }
	
}

public enum ServiceError: LocalizedError {
	case error(Error)
	case urlError(String? = nil)
    case invalidAuthToken(String)
    
   public var errorDescription: String? {
        switch self {
            case .error(let error): return error.localizedDescription
            case .urlError(let error): return error
            case .invalidAuthToken(let error): return error
        }
    }
}
