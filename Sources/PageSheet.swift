import SwiftUI

// MARK: - AutomaticPreferenceKey

private protocol AutomaticPreferenceKey: PreferenceKey {}

extension AutomaticPreferenceKey {
  fileprivate static func reduce(value: inout Value, nextValue: () -> Value) {
    value = nextValue()
  }
}

// MARK: - PageSheet

public enum PageSheet {
  public typealias Detent = UISheetPresentationController.Detent
  public typealias Detents = [Detent]

  // MARK: - Configuration

  fileprivate struct Configuration {
    var prefersGrabberVisible: Bool = false
    var detents: Detents = [.large()]
    var largestUndimmedDetentIdentifier: Detent.Identifier? = nil
    var selectedDetentIdentifier: Detent.Identifier? = nil
    var prefersEdgeAttachedInCompactHeight: Bool = false
    var widthFollowsPreferredContentSizeWhenEdgeAttached: Bool = false
    var prefersScrollingExpandsWhenScrolledToEdge: Bool = true
    var preferredCornerRadius: CGFloat? = nil

    static var `default`: Self { .init() }
  }

  // MARK: - ConfiguredHostingView

  fileprivate struct ConfiguredHostingView<Content: View>: View {

    @State
    private var configuration: Configuration = .default

    let content: Content

    var body: some View {
      HostingView(configuration: $configuration, content: content)
        .onPreferenceChange(Preference.GrabberVisible.self) { newValue in
          self.configuration.prefersGrabberVisible = newValue
        }
        .onPreferenceChange(Preference.Detents.self) { newValue in
          self.configuration.detents = newValue
        }
        .onPreferenceChange(Preference.LargestUndimmedDetentIdentifier.self) { newValue in
          self.configuration.largestUndimmedDetentIdentifier = newValue
        }
        .onPreferenceChange(Preference.SelectedDetentIdentifier.self) { newValue in
          self.configuration.selectedDetentIdentifier = newValue
        }
        .onPreferenceChange(Preference.EdgeAttachedInCompactHeight.self) { newValue in
          self.configuration.prefersEdgeAttachedInCompactHeight = newValue
        }
        .onPreferenceChange(Preference.WidthFollowsPreferredContentSizeWhenEdgeAttached.self) {
          newValue in
          self.configuration.widthFollowsPreferredContentSizeWhenEdgeAttached = newValue
        }
        .onPreferenceChange(Preference.ScrollingExpandsWhenScrolledToEdge.self) { newValue in
          self.configuration.prefersScrollingExpandsWhenScrolledToEdge = newValue
        }
        .onPreferenceChange(Preference.CornerRadius.self) { newValue in
          self.configuration.preferredCornerRadius = newValue
        }
        .ignoresSafeArea()
    }
  }

  // MARK: - HostingController

  fileprivate class HostingController<Content: View>: UIHostingController<Content>,
    UISheetPresentationControllerDelegate
  {
    var configuration: Configuration = .default {
      didSet {
        if let sheet = self.sheetPresentationController {
          sheet.delegate = self
          sheet.animateChanges {
            let config = self.configuration
            sheet.prefersGrabberVisible = config.prefersGrabberVisible
            sheet.detents = config.detents
            sheet.largestUndimmedDetentIdentifier = config.largestUndimmedDetentIdentifier
            sheet.prefersEdgeAttachedInCompactHeight = config.prefersEdgeAttachedInCompactHeight
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached =
              config.widthFollowsPreferredContentSizeWhenEdgeAttached
            sheet.prefersScrollingExpandsWhenScrolledToEdge =
              config.prefersScrollingExpandsWhenScrolledToEdge
            sheet.preferredCornerRadius = config.preferredCornerRadius

            self.selectedDetentChanged?(config.selectedDetentIdentifier)
            sheet.selectedDetentIdentifier = config.selectedDetentIdentifier
          }
        }
      }
    }

    var selectedDetentChanged: ((Detent.Identifier?) -> Void)?

    // MARK: UISheetPresentationControllerDelegate

    func sheetPresentationControllerDidChangeSelectedDetentIdentifier(
      _ sheet: UISheetPresentationController
    ) {
      selectedDetentChanged?(sheet.selectedDetentIdentifier)
    }
  }

  // MARK: - HostingView

  fileprivate struct HostingView<Content: View>: UIViewControllerRepresentable {
    typealias ModifiedView = ModifiedContent<
      Content, ApplySelectedDetentEnvironmentValueViewModifier
    >

    @Binding
    var configuration: Configuration

    @State
    private var selectedDetentIdentifier: Detent.Identifier?

    let content: Content

    func makeUIViewController(context: Context) -> HostingController<ModifiedView> {
      HostingController(
        rootView: content.modifier(
          ApplySelectedDetentEnvironmentValueViewModifier(
            selectedDetentIdentifier: $selectedDetentIdentifier
          )
        )
      )
    }

    func updateUIViewController(_ controller: HostingController<ModifiedView>, context: Context) {
      controller.selectedDetentChanged = { newDetent in
        // TODO: fixme
        // self.selectedDetentIdentifier = $0
      }
      controller.configuration = configuration
      controller.rootView = content.modifier(
        ApplySelectedDetentEnvironmentValueViewModifier(
          selectedDetentIdentifier: $selectedDetentIdentifier
        )
      )
    }
  }

  fileprivate struct ApplySelectedDetentEnvironmentValueViewModifier: ViewModifier {
    @Binding
    var selectedDetentIdentifier: Detent.Identifier?

    func body(content: Content) -> some View {
      Self._printChanges()
      return content.environment(\._selectedDetentIdentifier, selectedDetentIdentifier)
    }
  }
}

// MARK: - Presentation View Modifiers

extension PageSheet {

  fileprivate enum Modifier {

    // MARK: Presentation

    struct BooleanPresentation<SheetContent: View>: ViewModifier {

      @Binding
      var isPresented: Bool

      let onDismiss: (() -> Void)?
      let content: () -> SheetContent

      func body(content: Content) -> some View {
        content.sheet(isPresented: $isPresented, onDismiss: onDismiss) {
          ConfiguredHostingView(
            content: self.content()
          )
        }
      }
    }

    // MARK: ItemPresentation

    struct ItemPresentation<Item: Identifiable, SheetContent: View>: ViewModifier {

      @Binding
      var item: Item?

      let onDismiss: (() -> Void)?
      let content: (Item) -> SheetContent

      func body(content: Content) -> some View {
        content.sheet(item: $item, onDismiss: onDismiss) { item in
          ConfiguredHostingView(
            content: self.content(item)
          )
        }
      }
    }
  }

}

// MARK: Preferences

extension PageSheet {
  fileprivate enum Preference {
    struct GrabberVisible: AutomaticPreferenceKey {
      static var defaultValue: Bool = Configuration.default.prefersGrabberVisible
    }

    struct Detents: AutomaticPreferenceKey {
      static var defaultValue: PageSheet.Detents = Configuration.default.detents
    }

    struct LargestUndimmedDetentIdentifier: AutomaticPreferenceKey {
      static var defaultValue: Detent.Identifier? = Configuration.default
        .largestUndimmedDetentIdentifier
    }

    struct SelectedDetentIdentifier: AutomaticPreferenceKey {
      static var defaultValue: Detent.Identifier? = Configuration.default.selectedDetentIdentifier
    }

    struct EdgeAttachedInCompactHeight: AutomaticPreferenceKey {
      static var defaultValue: Bool = Configuration.default.prefersEdgeAttachedInCompactHeight
    }

    struct WidthFollowsPreferredContentSizeWhenEdgeAttached: AutomaticPreferenceKey {
      static var defaultValue: Bool = Configuration.default
        .widthFollowsPreferredContentSizeWhenEdgeAttached
    }

    struct ScrollingExpandsWhenScrolledToEdge: AutomaticPreferenceKey {
      static var defaultValue: Bool = Configuration.default
        .prefersScrollingExpandsWhenScrolledToEdge
    }

    struct CornerRadius: AutomaticPreferenceKey {
      static var defaultValue: CGFloat? = Configuration.default.preferredCornerRadius
    }
  }
}

// MARK: - Environment+PageSheet

// MARK: Internal

private struct SelectedDetentIdentifier: EnvironmentKey {
  static let defaultValue: PageSheet.Detent.Identifier? = nil
}

extension EnvironmentValues {
  fileprivate var _selectedDetentIdentifier: PageSheet.Detent.Identifier? {
    get { self[SelectedDetentIdentifier.self] }
    set { self[SelectedDetentIdentifier.self] = newValue }
  }
}

// MARK: External

extension EnvironmentValues {
  public var selectedDetentIdentifier: PageSheet.Detent.Identifier? {
    self[SelectedDetentIdentifier.self]
  }
}

// MARK: - View+PageSheet

extension View {

  // MARK: Presentation

  fileprivate typealias Modifier = PageSheet.Modifier

  /// Presents a page sheet when a binding to a Boolean value that you
  /// provide is true.
  ///
  /// Use this method when you want to present a modal view to the
  /// user when a Boolean value you provide is true. The example
  /// below displays a modal view of the mockup for a software license
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
  /// Use this method when you need to present a modal view with content
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

  fileprivate typealias Preference = PageSheet.Preference

  /// Sets a Boolean value that determines whether the presenting sheet shows a grabber at the top.
  ///
  /// The default value is `false`, which means the sheet doesn't show a grabber. A *grabber* is a visual affordance that indicates that a sheet is resizable.
  /// Showing a grabber may be useful when it isn't apparent that a sheet can resize or when the sheet can't dismiss interactively.
  ///
  /// Set this value to `true` for the system to draw a grabber in the standard system-defined location.
  /// The system automatically hides the grabber at appropriate times, like when the sheet is full screen in a compact-height size class or when another sheet presents on top of it.
  ///
  /// - Parameters:
  ///   - isVisible: Default value is `false`, set to `true` to display grabber.
  public func preferGrabberVisible(_ isVisible: Bool) -> some View {
    self.preference(key: Preference.GrabberVisible.self, value: isVisible)
  }

  /// Sets an array of heights where the presenting sheet can rest.
  ///
  /// - Parameters:
  ///   - detents: The default value is an array that contains the value ``large()``. This array must contain at least one element. When you set this value, specify detents in order from smallest to largest height.
  public func detents(_ detents: PageSheet.Detents) -> some View {
    self.preference(key: Preference.Detents.self, value: detents)
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
  /// - Parameters:
  ///   - identifier: Default value is `nil`.
  public func largestUndimmedDetentIdentifier(_ identifier: PageSheet.Detent.Identifier?)
    -> some View
  {
    self.preference(key: Preference.LargestUndimmedDetentIdentifier.self, value: identifier)
  }

  /// Sets the identifier of the most recently selected detent on the presenting sheet.
  ///
  /// This property represents the most recent detent that the user selects or that you set programmatically.
  /// The default value is `nil`, which means the sheet displays at the smallest detent you specify in ``detents``.
  ///
  /// - Parameters:
  ///  - identifier: Default value is `nil`.
  public func selectedDetentIdentifier(_ identifier: PageSheet.Detent.Identifier?) -> some View {
    self.preference(key: Preference.SelectedDetentIdentifier.self, value: identifier)
  }

  /// Sets a Boolean value that determines whether the presenting sheet attaches to the bottom edge of the screen in a compact-height size class.
  ///
  /// The default value is `false`, which means the sheet defaults to a full screen appearance at compact height.
  /// Set this value to `true` to use an alternate appearance in a compact-height size class, causing the sheet to only attach to the screen on its bottom edge.
  ///
  /// - Parameters:
  ///  - preference: Default value is `false`.
  public func preferEdgeAttachedInCompactHeight(_ preference: Bool) -> some View {
    self.preference(key: Preference.EdgeAttachedInCompactHeight.self, value: preference)
  }

  /// Sets a Boolean value that determines whether the presenting sheet's width matches its view's preferred content size.
  ///
  /// The default value is `false`, which means the sheet's width equals the width of its container's safe area.
  /// Set this value to `true` to use your view controller's ``preferredContentSize`` to determine the width of the sheet instead.
  ///
  /// This property doesn't have an effect when the sheet is in a compact-width and regular-height size class, or when ``prefersEdgeAttachedInCompactHeight`` is `false`.
  ///
  /// - Parameters:
  ///  - preference: Default value is `false`.
  public func widthFollowsPreferredContentSizeWhenEdgeAttached(_ preference: Bool) -> some View {
    self.preference(
      key: Preference.WidthFollowsPreferredContentSizeWhenEdgeAttached.self, value: preference)
  }

  /// Sets a Boolean value that determines whether scrolling expands the presenting sheet to a larger detent.
  ///
  /// The default value is `true`, which means if the sheet can expand to a larger detent than ``selectedDetentIdentifier``,
  /// scrolling up in the sheet increases its detent instead of scrolling the sheet's content. After the sheet reaches its largest detent, scrolling begins.
  ///
  /// Set this value to `false` if you want to avoid letting a scroll gesture expand the sheet.
  /// For example, you can set this value on a nonmodal sheet to avoid obscuring the content underneath the sheet.
  ///
  /// - Parameters:
  ///  - preference: Default value is `true`.
  public func preferScrollingExpandsWhenScrolledToEdge(_ preference: Bool) -> some View {
    self.preference(key: Preference.ScrollingExpandsWhenScrolledToEdge.self, value: preference)
  }

  /// Sets the preferred corner radius on the presenting sheet.
  ///
  /// The default value is `nil`. This property only has an effect when the presenting sheet is at the front of its sheet stack.
  ///
  /// - Parameters:
  ///  - preference: Default value is `nil`.
  /// - Returns: A view that wraps this view and sets the presenting sheet's ``cornerRadius``.
  public func preferredSheetCornerRadius(_ cornerRadius: CGFloat?) -> some View {
    self.preference(key: Preference.CornerRadius.self, value: cornerRadius)
  }
}
