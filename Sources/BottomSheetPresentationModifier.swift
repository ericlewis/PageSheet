import SwiftUI

struct BottomSheetPresentationModifier<SheetContent: View>: ViewModifier {
  @Binding
  var isPresented: Bool

  var onDismiss: (() -> Void)? = nil
  
  var contentBuilder: () -> SheetContent

  private var item: Binding<Bool?> {
    .init(
      get: { self.isPresented ? true : nil },
      set: { self.isPresented = ($0 != nil) }
    )
  }

  private func itemContentBuilder(bool: Bool) -> SheetContent {
    return contentBuilder()
  }

  func body(content: Content) -> some View {
    content.background(
      BottomSheetPresenter(
        item: item,
        onDismiss: onDismiss,
        contentBuilder: itemContentBuilder
      )
    )
  }
}

struct ItemBottomSheetPresentationModifier<Item: Identifiable, SheetContent: View>: ViewModifier {
  @Binding
  var item: Item?

  var onDismiss: (() -> Void)? = nil
  var contentBuilder: (Item) -> SheetContent

  func body(content: Content) -> some View {
    content.background(
      BottomSheetPresenter(
        item: $item,
        onDismiss: onDismiss,
        contentBuilder: contentBuilder
      )
    )
  }
}

extension View {

  /// Presents a sheet using `UISheetPresentationController` when a binding to a
  /// Boolean value that you provide is true.
  ///
  /// - Parameters:
  ///   - isPresented: A binding to a Boolean value that determines whether
  ///     to present the sheet that you create in the modifier's
  ///     `content` closure.
  ///   - onDismiss: The closure to execute when dismissing the sheet.
  ///   - content: A closure that returns the content of the sheet.
  public func bottomSheet<Content: View>(
    isPresented: Binding<Bool>,
    onDismiss: (() -> Void)? = nil,
    @ViewBuilder content builder: @escaping () -> Content
  ) -> some View {
    self.modifier(
      BottomSheetPresentationModifier(
        isPresented: isPresented,
        onDismiss: onDismiss,
        contentBuilder: builder
      )
    )
  }

  /// Presents a sheet via `UISheetPresentationController` using the given
  /// item as a data source for the sheet's content.
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
  public func bottomSheet<Item: Identifiable, Content: View>(
    item: Binding<Item?>,
    onDismiss: (() -> Void)? = nil,
    @ViewBuilder content builder: @escaping (Item) -> Content
  ) -> some View {
    self.modifier(
      ItemBottomSheetPresentationModifier(
        item: item,
        onDismiss: onDismiss,
        contentBuilder: builder
      )
    )
  }
}
