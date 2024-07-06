//
//  HTTPMethod.swift
//
//
//  Created by Baris Cem Baykara on 17.05.2024.
//

import Foundation

public enum HTTPMethod {
	case get
	case put((any Encodable)? = nil)
	case post((any Encodable)? = nil)
	case patch((any Encodable)? = nil)
	case delete
	case head
	case options
	case trace
	case connect
	
	public var description: String {
		switch self {
			case .get: "GET"
			case .put: "PUT"
			case .post: "POST"
			case .patch: "PATCH"
			case .delete: "DELETE"
			case .head: "HEAD"
			case .options: "OPTIONS"
			case .trace: "TRACE"
			case .connect: "CONNECT"
		}
	}
}
