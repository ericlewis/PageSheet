import SwiftUI

/// A SwiftUI wrapper view for presentation controllers that manages the appearance and behavior of a sheet.
///
/// Sheet presentation controllers specify a sheet's size based on a *detent*, a height where a sheet naturally rests.
/// Detents allow a sheet to resize from one edge of its fully expanded frame while the other three edges remain fixed.
/// You specify the detents that a sheet supports using `detents`, and monitor its most recently selected detent using `selectedDetentIdentifier`.
///
/// - Note: This view makes it easier to embed `PageSheetView` in custom navigation
/// solutions such as `FlowStacks` and is meant to be presented using a `sheet` modifier.
/// Other ways of presenting may not work, and are not officially supported.
///
public struct PageSheetView<Content>: View where Content: View {
  private let content: () -> Content

  /// Initializes and returns a presentation controller wrapped SwiftUI view.
  ///
  /// - Parameters
  ///   - content: A closure that returns the content of the sheet.
  ///
  public init(@ViewBuilder _ content: @escaping () -> Content) {
    self.content = content
  }

  public var body: some View {
    PageSheet.ConfiguredHostingView(content: content())
  }
}
