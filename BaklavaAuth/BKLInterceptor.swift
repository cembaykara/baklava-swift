import Foundation
@_spi(BKLInternal) import BaklavaCore

@_spi(BKLInternal) public struct BKLInterceptor: Interceptor {
    public var retryCount: Int
    public var delayInterval: TimeInterval
    
    public init(retryCount: Int = 2, delayInterval: TimeInterval = 2) {
        self.retryCount = max(0, retryCount)
        self.delayInterval = max(0, delayInterval)
    }
    
    public func adapt(request: URLRequest) async -> URLRequest {
        var adapted = request
        if let token = await Auth.shared.getAccessToken() {
            adapted.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        return adapted
    }
    
    public func retry(request: URLRequest, response: HTTPURLResponse) async {
        guard response.statusCode == 401 else { return }
        await Auth.shared.clearAuthState()
    }
}
