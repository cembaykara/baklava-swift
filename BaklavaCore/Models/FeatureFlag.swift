//
//  FeatureFlag.swift
//
//
//  Created by Baris Cem Baykara on 04.05.2024.
//

import Foundation

public protocol FeatureFlag: EntityProtocol {
	
	var id: UUID? { get set }
	
	var name: String { get set }
	
	var enabled: Bool { get set }
	
}
