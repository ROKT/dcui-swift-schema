# dcui-swift-schema
Swift package manager package for shared DCUI schema types. It contains the definitions of layout schema models, nodes and styles which can be utilized by Rokt libraries

## Installation

To install `dcui-swift-schema`, add the following dependency to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/ROKT/dcui-swift-schema.git", from: "2.0.0")
]
```

Then, add DcuiSchema to your target's dependencies:

```swift
targets: [
    .target(
        name: "YourTargetName",
        dependencies: ["DcuiSchema"]),
]
```


## Usage
Import the `DcuiSchema` module in your Swift files:
```Swift
import DcuiSchema  
```

Use the schema types as needed

## License
Copyright 2020 Rokt Pte Ltd

Licensed under the Rokt Software Development Kit (SDK) Terms of Use
Version 2.0 (the "License")

You may not use this file except in compliance with the License.

You may obtain a copy of the License at https://rokt.com/sdk-license-2-0/