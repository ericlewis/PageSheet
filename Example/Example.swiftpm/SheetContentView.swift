import SwiftUI
import PageSheet
import PageSheetPlus

struct SheetContentView: View {
  @Environment(\.dismiss)
  private var dismiss
  
  @State
  private var detents: [PageSheet.Detent] = [.medium(), .large()]
  
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
  private var selectedDetentId: PageSheet.Detent.Identifier? = nil
  
  @State
  private var largestUndimmedDetentId: PageSheet.Detent.Identifier? = nil
  
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
          Button("Medium & Large detent") { detents = [.medium(), .large()] }
        } header: {
          Text("Supported Detents")
        }
        Section {
          Button("Default detent") { largestUndimmedDetentId = nil }
          Button("Medium detent") { largestUndimmedDetentId = .medium }
          Button("Large detent") { largestUndimmedDetentId = .large }
        } header: {
          Text("Parent View Interaction")
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
      .interactiveDismissDisabled(dismissDisabled)
      .sheetPreferences {
        .detents(detents);
        .grabberVisible(grabberVisible);
        .selectedDetent(id: selectedDetentId);
        .largestUndimmedDetent(id: largestUndimmedDetentId);
        .scrollingExpandsWhenScrolledToEdge(prefersScrollingExpandsWhenScrolledToEdge);
        .edgeAttachedInCompactHeight(prefersEdgeAttachedInCompactHeight);
        .widthFollowsPreferredContentSizeWhenEdgeAttached(widthFollowsPreferredContentSizeWhenEdgeAttached);
        .largestUndimmedDetent(id: largestUndimmedDetentId);
      }
    }
    .pageSheet(isPresented: $childPresented) {
      SheetContentView()
    }
  }
}

