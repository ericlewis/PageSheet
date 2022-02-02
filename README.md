# PageSheet

[![](https://img.shields.io/badge/Swift_Package_Manager-compatible-ed702d.svg?style=flat)](https://github.com/apple/swift-package-manager)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fericlewis%2FPageSheet%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/ericlewis/PageSheet)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fericlewis%2FPageSheet%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/ericlewis/PageSheet)

#### Customizable sheet presentations in SwiftUI. Using [`UISheetPresentationController`](https://developer.apple.com/documentation/uikit/uisheetpresentationcontroller) under the hood.

### Features
- Uses the default [`sheet`](https://developer.apple.com/documentation/swiftui/view/sheet(ispresented:ondismiss:content:)) API under the hood, ensuring maximum compatibility & stability.
- Exposes the *exact same* API as the default SwiftUI [`sheet`](https://developer.apple.com/documentation/swiftui/view/sheet(ispresented:ondismiss:content:)) implementation.
- No hacks, follows the best practices for creating represetable views in SwiftUI.
- Configurable using view modifiers, can configure [`UISheetPresentationController`](https://developer.apple.com/documentation/uikit/uisheetpresentationcontroller)
  from any child views in the presented sheet's content view.
- Works with the [`interactiveDismissDisabled(_:Bool)`](https://developer.apple.com/documentation/swiftui/view/interactivedismissdisabled(_:)) modifier.
- Exposes all of the [`UISheetPresentationController`](https://developer.apple.com/documentation/uikit/uisheetpresentationcontroller) configuration options.
- Track the currently selected detent using an [`Environment`](https://developer.apple.com/documentation/swiftui/environment) value. 
- [Well documented API](#documentation), following a similar approach to the Developer Documentation.
- Small footprint, [`~44kB`](https://www.emergetools.com/) thin when installed via SwiftPM.

## Table of Contents
* [Requirements](#requirements)
* [Installation](#installation)
  * [Xcode](#xcode)
  * [Swift Package Manager](#swift-package-manager)
* [Examples](#examples)
  * [Example Project](#example-project)
  * [Presentation](#presentation)
  * [Customization](#customization)
* [Module Documentation](#module-documentation)
  * [PageSheet](#pagesheet)
  * [PageSheetCore](https://core-iota.vercel.app/documentation/)
  * [PageSheetPlus](https://page-sheet-doc-website.vercel.app/documentation/)
* [License](#license)

# Requirements
The codebase supports iOS and requires Xcode 12.0 or newer

# Installation
## Xcode
Open your project. Navigate to `File > Swift Packages > Add Package Dependency`. Enter the url `https://github.com/ericlewis/PageSheet` and tap `Next`.
Select the `PageSheet` target and press `Add Package`.

## Swift Package Manager
Add the following line to the `dependencies` in your `Package.swift` file:
```swift
.package(url: "https://github.com/ericlewis/PageSheet.git", .upToNextMajor(from: "1.0.0"))
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
          .upToNextMajor(from: "1.0.0"))
    ],
    targets: [
        .target(
          name: "AppTarget", 
          dependencies: ["PageSheet"])
    ]
)
```

# Examples
## Example Project
If you are using Xcode 13.2.1 you can navigate to the [`Example`](Example) folder and open the enclosed Swift App Playground to test various features (and see how they are implemented).

## Presentation
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

# Module Documentation
### PageSheet
`PageSheet` is split into three different modules, with `PageSheetCore` handling implementation
and `PageSheetPlus` providing a new modifier called `sheetPreferences(_:)`. 
The namesake module is `PageSheet`, which combines `PageSheetCore` & `PageSheetPlus` into a single import.

If you want to only use PageSheet without the fancy extra modifier (and [extra dependency](https://github.com/ericlewis/ViewModifierBuilder)), then use `PageSheetCore`.
### [PageSheetCore](https://core-iota.vercel.app/documentation/)
### [PageSheetPlus](https://page-sheet-doc-website.vercel.app/documentation/)

# License
PageSheet is released under the MIT license. See [LICENSE](LICENSE.md) for details.
