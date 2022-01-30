# BottomSheetView

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fericlewis%2FBottomSheetView%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/ericlewis/BottomSheetView)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fericlewis%2FBottomSheetView%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/ericlewis/BottomSheetView)

Present sheets with [`UISheetPresentationController`](https://developer.apple.com/documentation/uikit/uisheetpresentationcontroller) in SwiftUI.

## Requirements
The codebase supports iOS and requires Xcode 12.0 or newer

## Installation
### Xcode
Open your project. Navigate to `File > Swift Packages > Add Package Dependency`. Enter the url `https://github.com/ericlewis/BottomSheetView` and tap `Next`.
Select the `BottomSheetView` target and press `Add Package`.

### Swift Package Manager
Add the following line to the `dependencies` in your `Package.swift` file:
```swift
.package(url: "https://github.com/ericlewis/BottomSheetView.git", .upToNextMajor(from: "0.1.0"))
```
Next, add `BottomSheetView` as a dependency for your targets:
```swift
.target(name: "AppTarget", dependencies: ["BottomSheetView"])
```
A completed example may look like this:
```swift
// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "ExampleApp",
    dependencies: [
        .package(
          url: "https://github.com/ericlewis/BottomSheetView.git", 
          .upToNextMajor(from: "0.1.0"))
    ],
    targets: [
        .target(
          name: "ExampleAppTarget", 
          dependencies: ["BottomSheetView"])
    ]
)
```

## Examples
### Example Project
If you are using Xcode 13.2.1 you can navigate to the [`Example`](Example) folder and open the enclosed Swift App Playground to test various features (and see how they are implemented).

### Presentation
`BottomSheetView` works similarly to a typical [`sheet`](https://developer.apple.com/documentation/SwiftUI/View/sheet(isPresented:onDismiss:content:)) view modifier.
```swift
import SwiftUI
import BottomSheetView

struct ContentView: View {
  @State
  private var sheetPresented = false
  
  var body: some View {
    Button("Open Sheet") {
      sheetPresented = true
    }
    .bottomSheet(isPresented: $sheetPresented) {
      Text("Hello!")
    }
  }
}
```

`BottomSheetView` also supports presentation via conditional `Identifiable` objects.
```swift
import SwiftUI
import BottomSheetView

struct ContentView: View {
  @State
  private var string: String?
  
  var body: some View {
    Button("Open Sheet") {
      string = "Hello!"
    }
    .bottomSheet(item: $string) { unwrappedString in
      Text(unwrappedString)
    }
  }
}

extension String: Identifiable {
  public var id: String { self }
}
```

### Customization
`BottomSheetView` can also be customized using a collection of view modifiers applied to the bottom sheet's content.
```swift
import SwiftUI
import BottomSheetView

struct ContentView: View {
  @State
  private var sheetPresented = false
  
  var body: some View {
    Button("Open Sheet") {
      sheetPresented = true
    }
    .bottomSheet(isPresented: $sheetPresented) {
      Text("Hello!")
        .prefersGrabberVisible(true) // Always applied to children, similar to navigation views.
    }
  }
}
```

## Known Issues
- Largest undimmed detent changes seem to affect the dimming of accent color elements in parent views.
- Attempt to set a constant value for `item` or `isPresented` results in the sheet not being presented.
- Creating a bottom sheet & doing all layout work in the bottom sheet itself results in missing accent colors.
  - Workaround: instead, create a new `View` and use that in `.bottomSheet`

## License
BottomSheetView is released under the MIT license. See [LICENSE](LICENSE.md) for details.
