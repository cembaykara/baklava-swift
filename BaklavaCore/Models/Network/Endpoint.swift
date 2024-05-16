//
//  File.swift
//  
//
//  Created by Baris Cem Baykara on 07.05.2024.
//

import Foundation

public protocol EndpointParameter {
	
	func makeQueryItem() -> URLQueryItem
}

public protocol Endpoint {
	
	/// The base path for API endpoints.
	static var basePath: String { get }
	
	/// The path for API endpoints.
	var path: String { get }
}

public extension Endpoint {
	
	static private var host: String {
		guard let hostUrl = Baklava.configuration.host else { fatalError("No host address was provided. Did you configure Baklava correctly?") }
		return hostUrl
	}
	
	static func baseURL(with parameters: [any EndpointParameter]? = nil) -> URL? {
		return newComponent(with: parameters).url
	}
	
	func url(with parameters: [any EndpointParameter]? = nil) -> URL? {
		var component = Self.newComponent(with: parameters)
		component.path.append(path)
		return component.url
	}
	
	func url(with parameters: [any EndpointParameter]? = nil, custom: @escaping (URLComponents, String) -> URLComponents) -> URL? {
		return custom(Self.newComponent(with: parameters), path).url
	}
	
	private static func newComponent(with parameters: [any EndpointParameter]? = nil) -> URLComponents {
		var component = URLComponents()
		component.scheme = "https"
		component.host = Self.host
		component.path = Self.basePath
		
		guard let parameters = parameters else { return component }
		var queryItems: [URLQueryItem] = parameters.compactMap { $0.makeQueryItem() }
		component.queryItems = queryItems
		
		return component
	}
}
