# ``PageSheetPlus``

Contains the integration with ``ViewModifierBuilder`` to create the ``sheetPreferences(_:)`` modifier.

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

### Open Source
Check out the [GitHub Repo](https://github.com/ericlewis/PageSheet) to see how everything works.
