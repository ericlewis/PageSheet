import SwiftUI

struct DetentsPreferenceKey: PreferenceKey {
  static var defaultValue: [UISheetPresentationController.Detent] = [.large()]
  static func reduce(value: inout [UISheetPresentationController.Detent], nextValue: () -> [UISheetPresentationController.Detent]) {
    value = nextValue()
  }
}

struct LargestUndimmedDetentIdentifierPreferenceKey: PreferenceKey {
  static var defaultValue: UISheetPresentationController.Detent.Identifier? = nil
  static func reduce(value: inout UISheetPresentationController.Detent.Identifier?, nextValue: () -> UISheetPresentationController.Detent.Identifier?) {
    value = nextValue()
  }
}

struct PrefersScrollingExpandsWhenScrolledToEdgePreferenceKey: PreferenceKey {
  static var defaultValue: Bool = true

  static func reduce(value: inout Bool, nextValue: () -> Bool) {
    value = nextValue()
  }
}

struct PrefersGrabberVisiblePreferenceKey: PreferenceKey {
  static var defaultValue: Bool = false

  static func reduce(value: inout Bool, nextValue: () -> Bool) {
    value = nextValue()
  }
}

struct PrefersEdgeAttachedInCompactHeightPreferenceKey: PreferenceKey {
  static var defaultValue: Bool = false

  static func reduce(value: inout Bool, nextValue: () -> Bool) {
    value = nextValue()
  }
}

struct WidthFollowsPreferredContentSizeWhenEdgeAttachedPreferenceKey: PreferenceKey {
  static var defaultValue: Bool = false

  static func reduce(value: inout Bool, nextValue: () -> Bool) {
    value = nextValue()
  }
}

struct PreferredCornerRadiusPreferenceKey: PreferenceKey {
  static var defaultValue: CGFloat? = nil

  static func reduce(value: inout CGFloat?, nextValue: () -> CGFloat?) {
    value = nextValue()
  }
}

struct DismissDisabledPreferenceKey: PreferenceKey {
  static var defaultValue: Bool = false

  static func reduce(value: inout Bool, nextValue: () -> Bool) {
    value = nextValue()
  }
}

extension View {
  /// The array of heights where a sheet can rest.
  public func detents(_ detents: [UISheetPresentationController.Detent]) -> some View {
    self.preference(key: DetentsPreferenceKey.self, value: detents)
  }

  /// The largest detent that doesn’t dim the view underneath the sheet.
  public func largestUndimmedDetentIdentifier(_ id: UISheetPresentationController.Detent.Identifier?) -> some View {
    self.preference(key: LargestUndimmedDetentIdentifierPreferenceKey.self, value: id)
  }

  /// A Boolean value that determines whether scrolling expands the sheet to a larger detent.
  public func prefersScrollingExpandsWhenScrolledToEdge(_ preference: Bool) -> some View {
    self.preference(key: PrefersScrollingExpandsWhenScrolledToEdgePreferenceKey.self, value: preference)
  }

  /// A Boolean value that determines whether the sheet shows a grabber at the top.
  public func prefersGrabberVisible(_ preference: Bool) -> some View {
    self.preference(key: PrefersGrabberVisiblePreferenceKey.self, value: preference)
  }

  /// A Boolean value that determines whether the sheet attaches to the bottom edge of the screen in a compact-height size class.
  public func prefersEdgeAttachedInCompactHeight(_ preference: Bool) -> some View {
    self.preference(key: PrefersEdgeAttachedInCompactHeightPreferenceKey.self, value: preference)
  }

  /// A Boolean value that determines whether the sheet's width matches its view controller's preferred content size.
  public func widthFollowsPreferredContentSizeWhenEdgeAttached(_ preference: Bool) -> some View {
    self.preference(key: WidthFollowsPreferredContentSizeWhenEdgeAttachedPreferenceKey.self, value: preference)
  }

  /// The corner radius that the sheet attempts to present with.
  public func preferredCornerRadius(_ preference: CGFloat?) -> some View {
    self.preference(key: PreferredCornerRadiusPreferenceKey.self, value: preference)
  }


  /// Conditionally prevents interactive dismissal of a popover or a sheet.
  public func dismissDisabled(_ preference: Bool) -> some View {
    self.preference(key: DismissDisabledPreferenceKey.self, value: preference)
  }
}
