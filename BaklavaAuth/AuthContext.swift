import Foundation
@_spi(BKLInternal) import BaklavaCore

final actor AuthContext {
    private var configuration: AuthConfiguration = .init()
    private var accessToken: String?
    
    func setConfiguration(_ configuration: AuthConfiguration) {
        self.configuration = configuration
    }
    
    func getConfiguration() -> AuthConfiguration {
        configuration
    }
    
    func setAccessToken(_ accessToken: String?) {
        self.accessToken = accessToken
        if configuration.preferKeychain {
            do {
                try SecureStorage.set(object: accessToken, forKey: AuthKeys.authToken)
            } catch { }
        }
    }
    
    func getAccessToken() -> String? {
        if let accessToken { return accessToken }
        if configuration.preferKeychain {
            let keychainToken = try? SecureStorage.get(forKey: AuthKeys.authToken, toObject: String.self)
            accessToken = keychainToken
        }
        return accessToken
    }
}
