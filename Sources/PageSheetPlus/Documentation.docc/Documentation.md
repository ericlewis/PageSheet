# ``PageSheetPlus``

Contains the integration with ``ViewModifierBuilder`` to create the ``sheetPrefrences(_:)`` modifier.

## Example

```swift
import SwiftUI
import PageSheet
import PageSheetPlus

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
        .sheetPreferences {
          .detents([.medium(), .large()]);
          .grabberVisible(true);
        }
      }
    }
  }
}
```
