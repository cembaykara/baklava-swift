//
//  Storage.swift
//  BaklavaSDK
//
//  Created by Baris Cem Baykara on 06.10.2024.
//

@_spi(BKLInternal) public protocol Storage {
	
	static func set<T: Codable>(object: T, forKey storageKey: StorageKey) throws
	
	static func get<T: Codable>(forKey storageKey: StorageKey, toObject object: T.Type) throws -> T
	
	static func remove(forKey storageKey: StorageKey)
}

@_spi(BKLInternal) public protocol StorageKey {
	
	var value: String { get }
}
