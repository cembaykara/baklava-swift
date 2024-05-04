// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

public protocol FeatureFlag: EntityProtocol {
	
	var id: UUID? { get set }
	
	var name: String { get set }
	
	var enabled: Bool { get set }
	
}
