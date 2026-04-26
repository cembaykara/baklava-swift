import Foundation

/// Interceptor for adapting requests and handling retry side-effects.
public protocol Interceptor: Sendable {
    /// Indicates how many times the request will be retried.
    var retryCount: Int { get set }
    
    /// Indicates the delay between retries.
    var delayInterval: TimeInterval { get set }
    
    /// Adapts a request before execution.
    func adapt(request: URLRequest) async -> URLRequest
    
    /// Hook invoked for non-success HTTP responses before retry.
    func retry(request: URLRequest, response: HTTPURLResponse) async
}
