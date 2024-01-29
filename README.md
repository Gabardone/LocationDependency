# LocationDependency
[![Swift Package Manager compatible](https://img.shields.io/badge/SPM-compatible-4BC51D.svg?style=flat)](https://github.com/apple/swift-package-manager)
[![MIT License](https://img.shields.io/badge/SPM-compatible-4BC51D.svg?style=flat)](https://mit-license.org/)
[![Platforms](https://img.shields.io/badge/platform-ios%20%7C%20osx%20%7C%20tvos%20%7C%20visionos%20%7C%20watchos-%23989898)](https://apple.com/developer)

This is a simple abstracted file system dependency built for use with
[GlobalDependencies package](https://github.com/Gabardone/GlobalDependencies).

Since it's built to needs and so far I have just needed to perform the usual location permissions management and basic fetching of current location. As other facilities are needed, whether by myself or other helpful users, its protocol will get new methods
and its default implementation will make them work.

## Requirements

Since the default `LocationManager` protocol requires Swift concurrency, it is only supported on those versions of Apple platforms that support the language feature (major OS versions released in 2019 or later). `GlobalDependencies` requires macro support as well, which also contrain the toolset and minimum version of the package.

Some features also use the in-development `SwiftUX` library. It's a small dependency that doesn't bring others, you can ignore those bits if you want.

### Tools:

* Xcode 15.2 or later.
* Swift 5.9 or later.

### Platforms:

* iOS 14 or later.
* macOS Catalyst 14 or later (but why?).
* macOS 11 or later.
* tvOS 14 or later.
* visionOS 1 or later.
* watchOS 7 or later.

## Installation

LocationDependency is currently only supported through Swift Package Manager.

If developing your own package, you can add the following lines to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/Gabardone/FileSystemDependency", from: "2.0.0"),
]
```

To add to an Xcode project, paste `https://github.com/Gabardone/LocationDependency` into the URL field for a new package
and specify "Up to next major version" starting with the current one.

## How to Use `LocationDependency`

Documentation is a work in progress, but the logic is simple enough that it should be reasonably easy to figure out the use case as long as the use of `GlobalDependency` is understood.

## Contributing

If anyone decides to expand on this dependency (unsurprising as it's so limited so far) I would appreciate a PR with the
changes.

Same if anyone can come up with some more unit tests for the existing logic. I was drawing a blank since there's so
little of it and it mostly calls the system frameworks.

Beyond that just take to heart the baseline rules presented in  [contributing guidelines](Contributing.md) prior to
submitting a Pull Request.

Thanks, and happy networking!

## Developing

Double-click on `Package.swift` in the root of the repository to open the project in Xcode.
