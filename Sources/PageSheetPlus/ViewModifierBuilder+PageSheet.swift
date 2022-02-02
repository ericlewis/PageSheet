#if canImport(ViewModifierBuilder)
import PageSheet
import SwiftUI
import ViewModifierBuilder

extension ViewModifierBuilder {
  public static func buildExpression(_ preference: SheetPreference) -> SheetPreferenceViewModifier {
    .init(preference)
  }
}

extension View {
  public func sheetPreferences<V: ViewModifier>(
    @ViewModifierBuilder _ preferences: @escaping () -> V
  ) -> some View {
    self.modifier(preferences())
  }
}
#endif
