import SwiftUI

private struct SelectedDetentIdentifier: EnvironmentKey {
  static let defaultValue: PageSheet.Detent.Identifier? = nil
}

extension EnvironmentValues {
  internal var _selectedDetentIdentifier: PageSheet.Detent.Identifier? {
    get { self[SelectedDetentIdentifier.self] }
    set { self[SelectedDetentIdentifier.self] = newValue }
  }
}

// MARK: - Public

extension EnvironmentValues {
  /// The current ``Detent`` identifier of the sheet presentation associated with this environment.
  public var selectedDetentIdentifier: PageSheet.Detent.Identifier? {
    self[SelectedDetentIdentifier.self]
  }
}
