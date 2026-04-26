import Foundation

/// Password credentials.
public struct PasswordCredentials: Encodable, Credential, Sendable {
    /// Username of the user.
    public let username: String
    
    /// Password of the user.
    public let password: String
    
    internal let endpoint: AuthEndpoint
    
    private enum CodingKeys: CodingKey {
        case username
        case password
    }
    
    /// Initializes a `PasswordCredentials` object.
    public init(username: String, password: String) {
        self.username = username
        self.password = password
        self.endpoint = .password
    }
}
