#  ``PageSheet/PageSheetView``

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
    }
    .sheet(isPresented: $sheetPresented) {
      PageSheetView {
        VStack {
          Text("Hello, world!")
        }
        .sheetPreference(.detents([.medium(), .large()]))
        .sheetPreference(.grabberVisible(true))
      }
    }
  }
}
```

## Topics
