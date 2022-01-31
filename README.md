# PageSheet

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fericlewis%2FPageSheet%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/ericlewis/PageSheet)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fericlewis%2FPageSheet%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/ericlewis/PageSheet)

Present sheets using [`UISheetPresentationController`](https://developer.apple.com/documentation/uikit/uisheetpresentationcontroller) in SwiftUI.

## Table of Contents
* [Requirements](#requirements)
* [Installation](#installation)
* [Examples](#examples)
* [Known Issues](#known-issues)
* [License](#license)

## Requirements
The codebase supports iOS and requires Xcode 12.0 or newer

## Installation
### Xcode
Open your project. Navigate to `File > Swift Packages > Add Package Dependency`. Enter the url `https://github.com/ericlewis/PageSheet` and tap `Next`.
Select the `PageSheet` target and press `Add Package`.

### Swift Package Manager
Add the following line to the `dependencies` in your `Package.swift` file:
```swift
.package(url: "https://github.com/ericlewis/PageSheet.git", .upToNextMajor(from: "0.7.0"))
```
Next, add `PageSheet` as a dependency for your targets:
```swift
.target(name: "AppTarget", dependencies: ["PageSheet"])
```
A completed example may look like this:
```swift
// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "App",
    dependencies: [
        .package(
          url: "https://github.com/ericlewis/PageSheet.git", 
          .upToNextMajor(from: "0.7.0"))
    ],
    targets: [
        .target(
          name: "AppTarget", 
          dependencies: ["PageSheet"])
    ]
)
```

## Examples
### Example Project
If you are using Xcode 13.2.1 you can navigate to the [`Example`](Example) folder and open the enclosed Swift App Playground to test various features (and see how they are implemented).

### Presentation
`PageSheet` works similarly to a typical [`sheet`](https://developer.apple.com/documentation/SwiftUI/View/sheet(isPresented:onDismiss:content:)) view modifier.
```swift
import SwiftUI
import PageSheet

struct ContentView: View {
  @State
  private var sheetPresented = false
  
  var body: some View {
    Button("Open Sheet") {
      sheetPresented = true
    }
    .pageSheet(isPresented: $sheetPresented) {
      Text("Hello!")
    }
  }
}
```

`PageSheet` also supports presentation via conditional `Identifiable` objects.
```swift
import SwiftUI
import PageSheet

struct ContentView: View {
  @State
  private var string: String?
  
  var body: some View {
    Button("Open Sheet") {
      string = "Hello!"
    }
    .pageSheet(item: $string) { unwrappedString in
      Text(unwrappedString)
    }
  }
}

extension String: Identifiable {
  public var id: String { self }
}
```

### Customization
`PageSheet` can also be customized using a collection of view modifiers applied to the sheet's content.
```swift
import SwiftUI
import PageSheet

struct ContentView: View {
  @State
  private var sheetPresented = false
  
  var body: some View {
    Button("Open Sheet") {
      sheetPresented = true
    }
    .pageSheet(isPresented: $sheetPresented) {
      Text("Hello!")
        .preferGrabberVisible(true)
    }
  }
}
```


## Known Issues
- Largest undimmed detent seems to affect the dimming of accent color elements in parent views.
- The `selectedDetentIdentifier` value in `Environment` may not update if the selected `Detent` identifier is changed programmatically.

## License
PageSheet is released under the MIT license. See [LICENSE](LICENSE.md) for details.
