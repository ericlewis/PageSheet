# ``PageSheetCore/SheetPreference``

``SheetPreference`` is a bridge to the configuration used in [`UISheetPresentationController`](https://developer.apple.com/documentation/uikit/uisheetpresentationcontroller).

### Example

```swift
import SwiftUI
import PageSheet

struct ContentView: View {
  @State
  private var sheetPresented = false

  var body: some View {
    VStack {
      Button("Present Sheet") {
        sheetPresented = true
      }
      .pageSheet(isPresented: $sheetPresented) {
        VStack {
          Text("Hello, world!")
        }
        .sheetPreference(.grabberVisible(true))
      }
    }
  }
}
```

## Topics

### Specifying the Height
- ``detents(_:)``
- ``selectedDetent(id:)``
- ``PageSheet/Detent``

### Managing User Interaction
- ``largestUndimmedDetent(id:)``
- ``scrollingExpandsWhenScrolledToEdge(_:)``

### Managing the Appearance
- ``grabberVisible(_:)``
- ``edgeAttachedInCompactHeight(_:)``
- ``widthFollowsPreferredContentSizeWhenEdgeAttached(_:)``
- ``cornerRadius(_:)``
