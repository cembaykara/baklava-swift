# BaklavaSDK-Swift
 Welcome to the Baklava Swift SDK! This SDK provides convenient methods for interacting with the Baklava Server, a feature flag management system.

---

## Installation
##### Swift Package Manager
 You can install the BaklavaSDK via Swift Package Manager.
 - In Xcode, install the BaklavaSDK by navigating to File > Add Packages
 - And enter the GitHub link:
 ```https://github.com/cembaykara/baklava-swift```

 ##### With Package.swift
 Add the following package to your `Package.swift` dependencies:

 ```swift
 dependencies: [
     .package(url: "https://github.com/cembaykara/baklava-swift", from: "0.1.1"),
     ...
 ]
 ```
 Then in any target that depends on BaklavaSDK, add it to it's dependencies:
 
 ```swift
 .target(
     name: "YourTarget",
     dependencies: ["BaklavaSDK"]
 )
 ```

---

### Usage
 The SDK currently has two libraries **BaklavaCore** and **BaklavaServices**. You probobly want both of them added. If you are defining any Entity models you would want to:

 ```swift
 import BaklavaCore
 ```

 ###### Example
 ```swift
 import Foundation
 import BaklavaCore

 final class Flag: FeatureFlag {
	var id: UUID?
	var name: String
	var enabled: Bool
	
	init(id: UUID?, name: String, enabled: Bool) {
		self.id = id
		self.name = name
		self.enabled = enabled
	}
 }
 ```
 Core hosts common models, logger and some basic networking features. Everything except the public models will probobly be set to internal.
 
 #### Basic Authentication
 You will need to authenticate with your Baklava credentials. 
 The **BaklavaAuth** module has all the basic functianilit you would need to authenticate.

  ```swift
 import BaklavaAuth
 ```

 ```swift
 var user: User

 func login(username: String, password: String) async throws -> User {
	let credentials = PasswordLoginCredentials(username: username, password: password)
	user = try await Auth.login(with: credentials)
 }
 ``` 
 **Note:** The authentication module does not yet support persistent sessions.

 #### Services
 For interfacing with the API there is the **BaklavaServices** module.

 ```swift
 import BaklavaServices
 ```

 ###### Example
  ```swift
 import SwiftUI
 import BaklavaServices

  @Observable class FeatureFlagsViewModel {
	var flags: [Flag] = []

	private let service = Service(Flag.self)
	
	init() { fetchFlags() }
	
	func fetchFlags() async throws {
		flags = try await service.getFlags()
	}
    ...
  }
  ```

## Contributing
 We welcome contributions! If you encounter any issues or have suggestions for improvements, please open an issue or submit a pull request.
