//
//  SecureStorage.swift
//  BaklavaSDK
//
//  Created by Baris Cem Baykara on 06.10.2024.
//
import Foundation
import Security

@_spi(BKLInternal) public struct SecureStorage: Storage {
	
	public static func set<T>(object: T, forKey storageKey: any StorageKey) throws where T : Codable {
		do {
			let data = try JSONEncoder().encode(object)
			
			let query: [String: Any] = [
				kSecClass as String: kSecClassGenericPassword,
				kSecAttrAccount as String: storageKey.value
			]
			
			let attributes: [String: Any] = [
				kSecValueData as String: data
			]
			
			var status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
			
			if status == errSecItemNotFound {
				let newItem = query.merging(attributes) { (_, new) in new }
				status = SecItemAdd(newItem as CFDictionary, nil)
			}
		} catch { throw StorageError.error(error) }
	}
	
	public static func get<T>(forKey storageKey: any StorageKey, toObject object: T.Type) throws -> T where T : Codable {
		let query: [String: Any] = [
			kSecClass as String: kSecClassGenericPassword,
			kSecAttrAccount as String: storageKey.value,
			kSecReturnData as String: true,
			kSecMatchLimit as String: kSecMatchLimitOne
		]
		
		var data: AnyObject?
		let status = SecItemCopyMatching(query as CFDictionary, &data)
		
		if status == errSecSuccess, let retrievedData = data as? Data {
			do {
				let object = try JSONDecoder().decode(T.self, from: retrievedData)
				
				return object
			} catch { throw StorageError.error(error) }
		}
		
		throw StorageError.noSuchObjectfound
	}
	
	public static func remove(forKey storageKey: any StorageKey) {
		let query: [String: Any] = [
			kSecClass as String: kSecClassGenericPassword,
			kSecAttrAccount as String: storageKey.value,
			kSecReturnData as String: true,
			kSecMatchLimit as String: kSecMatchLimitOne
		]
		
		SecItemDelete(query as CFDictionary)
	}
	
	
}
