import SwiftUI
import PageSheet

struct ContentView: View {
  @State
  private var sheetPresented = false

  @State
  private var testSheetPresented = false

  @State
  private var count = 0

  var body: some View {
    NavigationView {
      List {
        Section {
          Button("Open Sheet") {
            sheetPresented = true
          }
          Button("Close Sheet") {
            sheetPresented = false
          }
        }
      }
      .pageSheet(isPresented: $sheetPresented) {
        SheetContentView()
      }
      .navigationTitle("PageSheet")
    }
  }
}

struct SheetContentView: View {
  @Environment(\.dismiss)
  private var dismiss

  @State
  private var count = 0

  @State
  private var detents: [UISheetPresentationController.Detent] = [.medium(), .large()]

  @State
  private var grabberVisible = true

  @State
  private var dismissDisabled = false

  @State
  private var childPresented = false

  @State
  private var prefersScrollingExpandsWhenScrolledToEdge = true

  @State
  private var prefersEdgeAttachedInCompactHeight = false

  @State
  private var widthFollowsPreferredContentSizeWhenEdgeAttached = false

  @State
  private var selectedDetentId: UISheetPresentationController.Detent.Identifier? = nil

  @Environment(\.selectedDetentIdentifier)
  private var selectedDetent

  var body: some View {
    NavigationView {
      List {
        Section {
          Text(selectedDetent?.rawValue ?? "nil")
          Button("Set detent to nil") {
            selectedDetentId = nil
          }
          Button("Set detent to medium") {
            selectedDetentId = .medium
          }
          Button("Set detent to large") {
            selectedDetentId = .large
          }
        } header: {
          Text("Selected Detent Identifier")
        }
        Section {
          Text(count, format: .number)
          Button("Increment") { count += 1 }
          Button("Decrement") { count -= 1 }
        } header: {
          Text("Local State Test")
        }
        Section {
          Toggle("Grabber visible", isOn: $grabberVisible)
          Toggle("Dismiss disabled", isOn: $dismissDisabled)
          Toggle("Scrolling expands when scrolled to edge", isOn: $prefersScrollingExpandsWhenScrolledToEdge)
          Toggle("Edge attached in compact height", isOn: $prefersEdgeAttachedInCompactHeight)
          Toggle("Width follows preferred content size when edge attached", isOn: $widthFollowsPreferredContentSizeWhenEdgeAttached)
        } header: {
          Text("Toggles")
        }
        Section {
          Button("Large detent only") { detents = [.large()] }
          Button("Medium detent only") { detents = [.medium()] }
          Button("Large & medium detent") { detents = [.medium(), .large()] }
        } header: {
          Text("Supported Detents")
        }
        Section {
          Button("Open child sheet") {
            childPresented = true
          }
        }
      }
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button("Dismiss") {
            dismiss()
          }
        }
      }
      .listStyle(.insetGrouped)
      .navigationTitle("Sheet View")
      .navigationBarTitleDisplayMode(.inline)
      .detents(detents)
      .preferGrabberVisible(grabberVisible)
      .interactiveDismissDisabled(dismissDisabled)
      .selectedDetentIdentifier(selectedDetentId)
      .preferredColorScheme(.dark)
      .sheet(isPresented: .constant(true)) {
        
      }

//      .prefersScrollingExpandsWhenScrolledToEdge(prefersScrollingExpandsWhenScrolledToEdge)
//      .prefersEdgeAttachedInCompactHeight(prefersEdgeAttachedInCompactHeight)
//      .widthFollowsPreferredContentSizeWhenEdgeAttached(widthFollowsPreferredContentSizeWhenEdgeAttached)
//      .largestUndimmedDetentIdentifier(.medium)
    }
    .pageSheet(isPresented: $childPresented) {
      SheetContentView()
    }
  }
}
