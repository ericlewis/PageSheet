import SwiftUI

private struct SelectedDetentIdentifier: EnvironmentKey {
  static let defaultValue: PageSheet.Detent.Identifier? = nil
}

private struct PreferenceNamespace: EnvironmentKey {
  static let defaultValue: Namespace.ID? = nil
}

extension EnvironmentValues {
  internal var _selectedDetentIdentifier: PageSheet.Detent.Identifier? {
    get { self[SelectedDetentIdentifier.self] }
    set { self[SelectedDetentIdentifier.self] = newValue }
  }

  internal var _preferenceNamespace: Namespace.ID? {
    get { self[PreferenceNamespace.self] }
    set { self[PreferenceNamespace.self] = newValue }
  }
}

// MARK: - Public

extension EnvironmentValues {
  /// The current ``Detent`` identifier of the sheet presentation associated with this environment.
  public var selectedDetentIdentifier: PageSheet.Detent.Identifier? {
    self[SelectedDetentIdentifier.self]
  }
}
