import SwiftUI
import PageSheet

struct ContentView: View {
  @State
  private var sheetPresented = false
  
  var body: some View {
    NavigationView {
      List {
        Section {
          Button("Open Sheet") {
            sheetPresented = true
          }
          .disabled(sheetPresented)
          
          Button("Close Sheet") {
            sheetPresented = false
          }
          .disabled(!sheetPresented)
          
        } header: {
          Text("Actions")
        }
      }
      .pageSheet(isPresented: $sheetPresented) {
        SheetContentView()
      }
      .navigationTitle("PageSheet")
    }
    .navigationViewStyle(.stack)
  }
}
