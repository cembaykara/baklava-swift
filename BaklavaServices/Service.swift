//
//  File.swift
//  
//
//  Created by Baris Cem Baykara on 04.05.2024.
//

import Foundation
import BaklavaCore

public struct Service<Entity> where Entity: EntityProtocol & Codable {
	
	public init (_ type: Entity.Type) { }
	
}

public enum ServiceError: LocalizedError {
	case error(Error)
	case urlError(String? = nil)
}
