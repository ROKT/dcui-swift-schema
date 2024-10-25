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
