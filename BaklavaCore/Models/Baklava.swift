//
//  FFSDK.swift
//
//
//  Created by Baris Cem Baykara on 04.05.2024.
//

import Foundation

public struct Baklava {
	
	private(set) static var configuration = BaklavaConfiguration()
	
	public static func setConfiguration(_ configuration: BaklavaConfiguration) {
		Baklava.configuration = configuration
	}
}
