//
//  EntityProtocol.swift
//  
//
//  Created by Baris Cem Baykara on 04.05.2024.
//

import Foundation

public protocol ResourceRepresentable {
    var id: UUID? { get set }
    var createdAt: Date? { get set }
    var updatedAt: Date? { get set }
}
