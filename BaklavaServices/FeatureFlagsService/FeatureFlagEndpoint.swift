//
//  FeatureFlagEndpoint.swift
//  
//
//  Created by Baris Cem Baykara on 16.05.2024.
//

import Foundation
@_spi(BKLInternal) import BaklavaCore

internal enum FeatureFlagEndpoint: Endpoint {
	case update(id: UUID)
	case delete(id: UUID)
	
	static var basePath: String { "/flags" }
	
	var path: String {
		switch self {
			case .update(let id): "/\(id)"
			case .delete(let id): "/\(id)"
		}
	}
}
