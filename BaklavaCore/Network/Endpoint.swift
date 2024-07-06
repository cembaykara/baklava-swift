//
//  File.swift
//  
//
//  Created by Baris Cem Baykara on 07.05.2024.
//

import Foundation

@_spi(BKLInternal) public protocol EndpointParameter {
	
	func makeQueryItem() -> URLQueryItem
}

@_spi(BKLInternal) public protocol Endpoint {
	
	/// The base path for API endpoints.
	static var basePath: String { get }
	
	/// The path for API endpoints.
	var path: String { get }
}

@_spi(BKLInternal) public extension Endpoint {
	
	static private var host: String {
		guard let hostUrl = Baklava.configuration.host else { fatalError("No host address was provided. Did you configure Baklava correctly?") }
		return hostUrl
	}
	
	static private var port: Int? {
		return Baklava.configuration.port
	}
	
	static private var preferSecureConnection: Bool {
		return !Baklava.configuration.disableSecureConnection
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
		component.scheme = preferSecureConnection ? "https" : "http"
		component.host = Self.host
		component.path = Self.basePath
		
		if let port = self.port { component.port = port }
		
		guard let parameters = parameters else { return component }
		let queryItems: [URLQueryItem] = parameters.compactMap { $0.makeQueryItem() }
		component.queryItems = queryItems
		
		return component
	}
}
