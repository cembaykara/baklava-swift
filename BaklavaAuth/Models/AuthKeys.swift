//
//  AuthKeys.swift
//  BaklavaSDK
//
//  Created by Baris Cem Baykara on 07.10.2024.
//
@_spi(BKLInternal) import BaklavaCore

internal enum AuthKeys: StorageKey {
	case authToken
	
	var value: String {
		switch self {
			case .authToken: return "authToken"
		}
	}
}
