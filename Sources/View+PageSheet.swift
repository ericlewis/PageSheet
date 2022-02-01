import SwiftUI

extension View {

  // MARK: Presentation

  fileprivate typealias Modifier = PageSheet.Modifier

  /// Presents a page sheet when a binding to a Boolean value that you
  /// provide is true.
  ///
  /// Use this method when you want to present a sheet view to the
  /// user when a Boolean value you provide is true. The example
  /// below displays a sheet view of the mockup for a software license
  /// agreement when the user toggles the `isShowingSheet` variable by
  /// clicking or tapping on the "Show License Agreement" button:
  ///
  ///     struct ShowLicenseAgreement: View {
  ///         @State private var isShowingSheet = false
  ///         var body: some View {
  ///             Button(action: {
  ///                 isShowingSheet.toggle()
  ///             }) {
  ///                 Text("Show License Agreement")
  ///             }
  ///             .pageSheet(isPresented: $isShowingSheet,
  ///                    onDismiss: didDismiss) {
  ///                 VStack {
  ///                     Text("License Agreement")
  ///                         .font(.title)
  ///                         .padding(50)
  ///                     Text("""
  ///                             Terms and conditions go here.
  ///                         """)
  ///                         .padding(50)
  ///                     Button("Dismiss",
  ///                            action: { isShowingSheet.toggle() })
  ///                 }
  ///                 .detents([.medium(), .large()])
  ///             }
  ///         }
  ///
  ///         func didDismiss() {
  ///             // Handle the dismissing action.
  ///         }
  ///     }
  ///
  /// - Parameters:
  ///   - isPresented: A binding to a Boolean value that determines whether
  ///     to present the sheet that you create in the modifier's
  ///     `content` closure.
  ///   - onDismiss: The closure to execute when dismissing the sheet.
  ///   - content: A closure that returns the content of the sheet.
  public func pageSheet<Content: View>(
    isPresented: Binding<Bool>, onDismiss: (() -> Void)? = nil,
    @ViewBuilder content: @escaping () -> Content
  ) -> some View {
    self.modifier(
      Modifier.BooleanPresentation(isPresented: isPresented, onDismiss: onDismiss, content: content)
    )
  }

  /// Presents a page sheet using the given item as a data source
  /// for the sheet's content.
  ///
  /// Use this method when you need to present a sheet view with content
  /// from a custom data source. The example below shows a custom data source
  /// `InventoryItem` that the `content` closure uses to populate the display
  /// the action sheet shows to the user:
  ///
  ///     struct ShowPartDetail: View {
  ///         @State var sheetDetail: InventoryItem?
  ///         var body: some View {
  ///             Button("Show Part Details") {
  ///                 sheetDetail = InventoryItem(
  ///                     id: "0123456789",
  ///                     partNumber: "Z-1234A",
  ///                     quantity: 100,
  ///                     name: "Widget")
  ///             }
  ///             .pageSheet(item: $sheetDetail,
  ///                    onDismiss: didDismiss) { detail in
  ///                 VStack(alignment: .leading, spacing: 20) {
  ///                     Text("Part Number: \(detail.partNumber)")
  ///                     Text("Name: \(detail.name)")
  ///                     Text("Quantity On-Hand: \(detail.quantity)")
  ///                 }
  ///                 .onTapGesture {
  ///                     sheetDetail = nil
  ///                 }
  ///                 .detents([.medium(), .large()])
  ///             }
  ///         }
  ///
  ///         func didDismiss() {
  ///             // Handle the dismissing action.
  ///         }
  ///     }
  ///
  ///     struct InventoryItem: Identifiable {
  ///         var id: String
  ///         let partNumber: String
  ///         let quantity: Int
  ///         let name: String
  ///     }
  ///
  /// - Parameters:
  ///   - item: A binding to an optional source of truth for the sheet.
  ///     When `item` is non-`nil`, the system passes the item's content to
  ///     the modifier's closure. You display this content in a sheet that you
  ///     create that the system displays to the user. If `item` changes,
  ///     the system dismisses the sheet and replaces it with a new one
  ///     using the same process.
  ///   - onDismiss: The closure to execute when dismissing the sheet.
  ///   - content: A closure returning the content of the sheet.
  public func pageSheet<Item: Identifiable, V: View>(
    item: Binding<Item?>, onDismiss: (() -> Void)? = nil,
    @ViewBuilder content: @escaping (Item) -> V
  ) -> some View {
    self.modifier(Modifier.ItemPresentation(item: item, onDismiss: onDismiss, content: content))
  }

  // MARK: Preferences

  public typealias Preference = PageSheet.Preference

  /// Sets a Boolean value that determines whether the presenting sheet shows a grabber at the top.
  ///
  /// The default value is `false`, which means the sheet doesn't show a grabber. A *grabber* is a visual affordance that indicates that a sheet is resizable.
  /// Showing a grabber may be useful when it isn't apparent that a sheet can resize or when the sheet can't dismiss interactively.
  ///
  /// Set this value to `true` for the system to draw a grabber in the standard system-defined location.
  /// The system automatically hides the grabber at appropriate times, like when the sheet is full screen in a compact-height size class or when another sheet presents on top of it.
  ///
  /// - Note: This modifier only takes effect when this view is inside of and visible within a presented ``PageSheet``. You can apply the modifier to any view in the sheet’s view hierarchy.
  ///
  /// - Parameters:
  ///   - isVisible: Default value is `false`, set to `true` to display grabber.
  /// - Returns: A view that wraps this view and sets the presenting sheet's grabber visiblity.
  @inlinable public func preferGrabberVisible(_ isVisible: Bool) -> some View {
    self.sheetPreference(.grabberVisible(isVisible))
  }

  /// Sets an array of heights where the presenting sheet can rest.
  ///
  /// The default value is an array that contains the value ``large()``.
  /// The array must contain at least one element. When you set this value, specify detents in order from smallest to largest height.
  ///
  /// - Note: This modifier only takes effect when this view is inside of and visible within a presented ``PageSheet``. You can apply the modifier to any view in the sheet’s view hierarchy.
  ///
  /// - Parameters:
  ///   - detents: The default value is an array that contains the value ``large()``.
  /// - Returns: A view that wraps this view and sets the presenting sheet's  ``UISheetPresentationController/detents``.
  @inlinable public func detents(_ detents: PageSheet.Detents) -> some View {
    self.sheetPreference(.detents(detents))
  }

  /// Sets the largest detent that doesn’t dim the view underneath the presenting sheet.
  ///
  /// The default value is `nil`, which means the system adds a noninteractive dimming view underneath the sheet at all detents.
  /// Set this property to only add the dimming view at detents larger than the detent you specify.
  /// For example, set this property to ``medium`` to add the dimming view at the ``large`` detent.
  ///
  /// Without a dimming view, the undimmed area around the sheet responds to user interaction, allowing for a nonmodal experience.
  /// You can use this behavior for sheets with interactive content underneath them.
  ///
  /// - Note: This modifier only takes effect when this view is inside of and visible within a presented ``PageSheet``. You can apply the modifier to any view in the sheet’s view hierarchy.
  ///
  /// - Parameters:
  ///   - id: A ``PageSheet.Detent.Identifier`` value, the default is `nil`.
  /// - Returns: A view that wraps this view and sets the presenting sheet's largest undimmed `Detent` identifier.
  @inlinable public func largestUndimmedDetent(id identifier: PageSheet.Detent.Identifier?)
    -> some View
  {
    self.sheetPreference(.largestUndimmedDetent(id: identifier))
  }

  /// Sets the identifier of the most recently selected detent on the presenting sheet.
  ///
  /// This property represents the most recent detent that the user selects or that you set programmatically.
  /// The default value is `nil`, which means the sheet displays at the smallest detent you specify in ``detents``.
  ///
  /// - Note: This modifier only takes effect when this view is inside of and visible within a presented ``PageSheet``. You can apply the modifier to any view in the sheet’s view hierarchy.
  ///
  /// - Parameters:
  ///   - id: A ``PageSheet.Detent.Identifier`` value, the default is `nil`.
  /// - Returns: A view that wraps this view and sets the presenting sheet's selected `Detent` identifier.
  @inlinable public func selectedDetent(id identifier: PageSheet.Detent.Identifier?) -> some View {
    self.sheetPreference(.selectedDetent(id: identifier))
  }

  /// Sets a Boolean value that determines whether the presenting sheet attaches to the bottom edge of the screen in a compact-height size class.
  ///
  /// The default value is `false`, which means the sheet defaults to a full screen appearance at compact height.
  /// Set this value to `true` to use an alternate appearance in a compact-height size class, causing the sheet to only attach to the screen on its bottom edge.
  ///
  /// - Note: This modifier only takes effect when this view is inside of and visible within a presented ``PageSheet``. You can apply the modifier to any view in the sheet’s view hierarchy.
  ///
  /// - Parameters:
  ///  - preference: Default value is `false`.
  /// - Returns: A view that wraps this view and sets the presenting sheet's ``prefersEdgeAttachedInCompactHeight`` property.
  @inlinable public func preferEdgeAttachedInCompactHeight(_ preference: Bool) -> some View {
    self.sheetPreference(.edgeAttachedInCompactHeight(preference))
  }

  /// Sets a Boolean value that determines whether the presenting sheet's width matches its view's preferred content size.
  ///
  /// The default value is `false`, which means the sheet's width equals the width of its container's safe area.
  /// Set this value to `true` to use your view controller's ``preferredContentSize`` to determine the width of the sheet instead.
  ///
  /// This property doesn't have an effect when the sheet is in a compact-width and regular-height size class, or when ``prefersEdgeAttachedInCompactHeight`` is `false`.
  ///
  /// - Note: This modifier only takes effect when this view is inside of and visible within a presented ``PageSheet``. You can apply the modifier to any view in the sheet’s view hierarchy.
  ///
  /// - Parameters:
  ///  - preference: Default value is `false`.
  /// - Returns: A view that wraps this view and sets the presenting sheet's ``prefersEdgeAttachedInCompactHeight`` property.
  @inlinable public func widthFollowsPreferredContentSizeWhenEdgeAttached(_ preference: Bool)
    -> some View
  {
    self.sheetPreference(.widthFollowsPreferredContentSizeWhenEdgeAttached(preference))
  }

  /// Sets a Boolean value that determines whether scrolling expands the presenting sheet to a larger detent.
  ///
  /// The default value is `true`, which means if the sheet can expand to a larger detent than ``selectedDetentIdentifier``,
  /// scrolling up in the sheet increases its detent instead of scrolling the sheet's content. After the sheet reaches its largest detent, scrolling begins.
  ///
  /// Set this value to `false` if you want to avoid letting a scroll gesture expand the sheet.
  /// For example, you can set this value on a nonmodal sheet to avoid obscuring the content underneath the sheet.
  ///
  /// - Note: This modifier only takes effect when this view is inside of and visible within a presented ``PageSheet``. You can apply the modifier to any view in the sheet’s view hierarchy.
  ///
  /// - Parameters:
  ///  - preference: Default value is `true`.
  /// - Returns: A view that wraps this view and sets the presenting sheet's ``prefersScrollingExpandsWhenScrolledToEdge`` property.
  @inlinable public func preferScrollingExpandsWhenScrolledToEdge(_ preference: Bool) -> some View {
    self.sheetPreference(.scrollingExpandsWhenScrolledToEdge(preference))
  }

  /// Sets the preferred corner radius on the presenting sheet.
  ///
  /// The default value is `nil`. This property only has an effect when the presenting sheet is at the front of its sheet stack.
  ///
  /// - Note: This modifier only takes effect when this view is inside of and visible within a presented ``PageSheet``. You can apply the modifier to any view in the sheet’s view hierarchy.
  ///
  /// - Parameters:
  ///  - preference: Default value is `nil`.
  /// - Returns: A view that wraps this view and sets the presenting sheet's ``cornerRadius``.
  @inlinable public func preferredSheetCornerRadius(_ cornerRadius: CGFloat?) -> some View {
    self.sheetPreference(.cornerRadius(cornerRadius))
  }

  /// Sets the presenting sheet's preferences using the provided preference.
  ///
  ///  Applies a ``PageSheet/PageSheet/PresentationPreference`` to the view.
  ///  Use this modifier instead of the modifiers that apply directly to a view. This aids in creating consistency
  ///  and discoverability when setting a sheet's presentation preferences.
  ///
  /// - Note: This modifier only takes effect when this view is inside of and visible within a presented ``PageSheet``. You can apply the modifier to any view in the sheet’s view hierarchy.
  ///
  /// - Parameters:
  ///   - preference: A preference that can be applied to the current sheet presentation.
  ///
  /// - Returns: A view that has the given preference applied.
  ///
  @inlinable public func sheetPreference(_ preference: PageSheet.PresentationPreference)
    -> some View
  {
    self.modifier(PageSheet.PresentationPreferenceViewModifier(preference))
  }
}
