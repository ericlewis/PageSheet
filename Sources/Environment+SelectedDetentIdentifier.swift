import SwiftUI

private struct SelectedDetentIdentifierKey: EnvironmentKey {
  static let defaultValue: UISheetPresentationController.Detent.Identifier? = nil
}

extension EnvironmentValues {
  public var selectedDetentIdentifier: UISheetPresentationController.Detent.Identifier? {
    get { self[SelectedDetentIdentifierKey.self] }
  }

  var _selectedDetentIdentifier: UISheetPresentationController.Detent.Identifier? {
    get { self[SelectedDetentIdentifierKey.self] }
    set { self[SelectedDetentIdentifierKey.self] = newValue }
  }
}

extension View {
  func environmentSelectedDetentIdentifier(_ id: UISheetPresentationController.Detent.Identifier? = nil) -> some View {
    self.environment(\._selectedDetentIdentifier, id)
  }
}
