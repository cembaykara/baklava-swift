//
//  Errors.swift
//  BaklavaSDK
//
//  Created by Baris Cem Baykara on 06.10.2024.
//
import SwiftUI

/// Storage error
public enum StorageError: LocalizedError {
	case error(Error)
	case encodingFailed
	case decodingFailed
	case noSuchObjectfound
}
