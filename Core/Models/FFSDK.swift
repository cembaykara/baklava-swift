//
//  FFSDK.swift
//
//
//  Created by Baris Cem Baykara on 04.05.2024.
//

import Foundation

public struct FFSDK {
	
	private(set) static var configuration = FFSDKConfiguration()
	
	public static func setConfiguration(_ configuration: FFSDKConfiguration) {
		FFSDK.configuration = configuration
	}
}
