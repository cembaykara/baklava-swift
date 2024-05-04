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
     .package(url: "https://github.com/cembaykara/baklava-swift", from: "0.1.0"),
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
 The SDK currently has two libraries **Core** and **Services**. You probobly want both of them added. If you are defining any Entity models you would want to:

 ```swift
 import Core
 ```

 ###### Example
 ```swift
 import Foundation
 import Core

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
 Core hosts common models, logger and some basic networking features. Everything except the models will probobly be set internal.
 
 For the networking logic you would need the **Services** module.

 ```swift
 import Core
 ```

 ###### Example
  ```swift
 import Foundation
 import Combine
 import Services

  @Observable class FeatureFlagsViewModel {
	var flags: [Flag] = []

    private var cancellable = Set<AnyCancellable>()
	private let service = Service(Flag.self)
	
	init() { fetchFlags() }
	
	func fetchFlags() {
		service.getFlags()
			.sink { print($0) } receiveValue: { self.flags = $0 }
			.store(in: &cancellable)
	}
    ...
  }
  ```

## Contributing
 We welcome contributions! If you encounter any issues or have suggestions for improvements, please open an issue or submit a pull request.
