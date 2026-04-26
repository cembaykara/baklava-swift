import Foundation

public struct Response<T: ResourceRepresentable & Codable>: Codable {
    public let data: T
    
    public init(data: T) {
        self.data = data
    }
}

public struct PageResponse<T: ResourceRepresentable & Codable>: Codable {
    public let data: [T]
    
    public init(data: [T]) {
        self.data = data
    }
}
