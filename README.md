# dcui-swift-schema
Swift package manager package for shared DCUI schema types. It contains the definitions of layout schema models, nodes and styles which can be utilized by Rokt libraries

## Resident Experts
- Danial Motahari - <danial.motahari@rokt.com>
- Wei Yew Teoh - <wei.yew.teoh@rokt.com>
- Thomson Thomas - <thomson.thomas@rokt.com>

## Requirements

Swift 5.5 or higher. The package is compatible with iOS 13.0 and above.

## Project architecture

This Swift package defines the shared schema models for DCUI (Dynamic Content UI) which are used across Rokt libraries. The package primarily contains:

- Layout schema models
- Node definitions
- Style definitions

These types are designed to be used as a foundation for rendering dynamic UI layouts in iOS applications.

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

## How to run tests locally?

Select the DcuiSchema scheme, select an iPhone and press command + U, or Product -> Test menu in Xcode.
## FAQ

### What are the branches?

The main branches of this repository include: **master**, **release-** and **feature branches**

* **master** - Main development branch
* **release branches** - Branches with **release-** prefix are considered production branches.
* **feature branches** - All other branches are considered feature branches.

### What are the versions?
We are using semantic versioning starting with version 1.0.0. Each new feature requires incrementing minor version and breaking changes require incrementing major version.

### Something is not working, what do I do?

In case you run into any problems you can try:

* Clean the build folder of the project. Select menu: Product -> Clean Build Folder on Xcode
* Delete the derived data folder for the project
* Make sure you're using the correct Swift version

## License

Copyright 2020 Rokt Pte Ltd

Licensed under the Rokt Software Development Kit (SDK) Terms of Use
Version 2.0 (the "License")

You may not use this file except in compliance with the License.

You may obtain a copy of the License at https://rokt.com/sdk-license-2-0/
