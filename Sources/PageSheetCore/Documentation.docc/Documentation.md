# ``PageSheetCore``

 Customizable sheet presentations in SwiftUI. 
 
### Features

- Uses [`UISheetPresentationController`](https://developer.apple.com/documentation/uikit/uisheetpresentationcontroller)
- Uses the default [`sheet`](https://developer.apple.com/documentation/swiftui/view/sheet(ispresented:ondismiss:content:)) for presentation, ensuring maximum compatibility & stability.
- Exposes the *exact same* API as the default SwiftUI [`sheet`](https://developer.apple.com/documentation/swiftui/view/sheet(ispresented:ondismiss:content:)) implementation.
- No hacks, follows the best practices for creating represetable views in SwiftUI.
- Configurable using view modifiers, can configure [`UISheetPresentationController`](https://developer.apple.com/documentation/uikit/uisheetpresentationcontroller)
  from any child views in the presented sheet's content view.
- Works with the [`interactiveDismissDisabled(_:Bool)`](https://developer.apple.com/documentation/swiftui/view/interactivedismissdisabled(_:)) modifier.
- Exposes all of the [`UISheetPresentationController`](https://developer.apple.com/documentation/uikit/uisheetpresentationcontroller) configuration options.
- Track the currently selected detent using an [`Environment`](https://developer.apple.com/documentation/swiftui/environment) value. 
- Well documented API, following a similar approach to the Developer Documentation.
- Small footprint, [`~44.0kB`](https://www.emergetools.com/) thin installed via SwiftPM.

### Open Source
Check out the [GitHub Repo](https://github.com/ericlewis/PageSheet) to see how everything works.

## Topics

### Customization
- ``SheetPreference``
- ``SheetPreferenceViewModifier``

### Presentation
- ``PageSheetView``

### Supporting Types
- ``PageSheet``
- ``PageSheet/Preference``
