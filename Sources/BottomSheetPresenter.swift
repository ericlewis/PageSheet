import SwiftUI

struct BottomSheetPresenter<Item: Identifiable, Content: View>: UIViewRepresentable {
  @Binding
  var item: Item?

  var onDismiss: (() -> Void)? = nil
  var contentBuilder: (Item) -> Content

  func makeCoordinator() -> Coordinator {
    Coordinator(parent: self)
  }

  func makeUIView(context: Context) -> some UIView {
    return context.coordinator.uiView
  }

  func updateUIView(_ uiView: UIViewType, context: Context) {
    context.coordinator.parent = self
    context.coordinator.item = item
  }
}

extension BottomSheetPresenter {
  class Coordinator: NSObject, UISheetPresentationControllerDelegate, UIAdaptivePresentationControllerDelegate {
    var parent: BottomSheetPresenter

    init(parent: BottomSheetPresenter) {
      self.parent = parent
    }

    private weak var viewController: UIViewController?

    lazy var uiView: UIView = {
      let view = UIView()
      view.backgroundColor = .clear
      return view
    }()

    var item: Item? {
      didSet(oldItem) {
        handleItemChange(from: oldItem, to: item)
      }
    }

    private var dismissDisabled = false

    private func handleItemChange(from oldItem: Item?, to newItem: Item?) {
      switch (oldItem, newItem) {
      case (.none, .none):
        break
      case let (.none, .some(newItem)):
        presentSheet(with: newItem)
      case let (.some(oldItem), .some(newItem)) where oldItem.id != newItem.id:
        updateSheet(with: newItem)
      case let (.some, .some(newItem)):
        updateSheet(with: newItem)
      case (.some, .none):
        dismissSheet()
      }
    }

    private func presentSheet(with item: Item) {
      let content = buildContent(with: item)
      let viewController = UIHostingController(rootView: content)

      guard let presentingViewController = uiView.viewController else {
        self.resetItemBinding()
        return
      }

      if let sheet = viewController.sheetPresentationController {
        sheet.delegate = self
      }

      presentingViewController.present(viewController, animated: true)
      self.viewController = viewController
    }

    private func dismissSheet() {
      guard let viewController = self.viewController else {
        return
      }

      viewController.dismiss(animated: true) {
        self.handleDismissal()
      }
    }

    private func updateSheet(with item: Item) {
      (self.viewController as? UIHostingController)?.rootView = buildContent(with: item)
      
    }

    private func buildContent(with item: Item) -> some View {
      parent.contentBuilder(item)
        .modifier(
          PresentationWatcherViewModifier(
            presentationModeChanged: {
              if !$0 && self.item != nil {
                self.resetItemBindingAndHandleDismissal()
              }
            }
          )
        )
        .onPreferenceChange(DetentsPreferenceKey.self) { detents in
          if let sheet = self.viewController?.sheetPresentationController {
            guard detents != sheet.detents else {
              return
            }

            sheet.animateChanges {
              sheet.detents = detents
            }
          }
        }.onPreferenceChange(LargestUndimmedDetentIdentifierPreferenceKey.self) { id in
          if let sheet = self.viewController?.sheetPresentationController {
            guard id != sheet.largestUndimmedDetentIdentifier else {
              return
            }

            sheet.animateChanges {
              sheet.largestUndimmedDetentIdentifier = id
            }
          }
        }.onPreferenceChange(PrefersScrollingExpandsWhenScrolledToEdgePreferenceKey.self) { preference in
          if let sheet = self.viewController?.sheetPresentationController {
            guard preference != sheet.prefersScrollingExpandsWhenScrolledToEdge else {
              return
            }

            sheet.prefersScrollingExpandsWhenScrolledToEdge = preference
          }
        }.onPreferenceChange(PrefersGrabberVisiblePreferenceKey.self) { isVisible in
          if let sheet = self.viewController?.sheetPresentationController {
            guard isVisible != sheet.prefersGrabberVisible else {
              return
            }

            sheet.animateChanges {
              sheet.prefersGrabberVisible = isVisible
            }
          }
        }.onPreferenceChange(PrefersEdgeAttachedInCompactHeightPreferenceKey.self) { preference in
          if let sheet = self.viewController?.sheetPresentationController {
            guard preference != sheet.prefersEdgeAttachedInCompactHeight else {
              return
            }

            sheet.animateChanges {
              sheet.prefersEdgeAttachedInCompactHeight = preference
            }
          }
        }.onPreferenceChange(WidthFollowsPreferredContentSizeWhenEdgeAttachedPreferenceKey.self) { preference in
          if let sheet = self.viewController?.sheetPresentationController {
            guard preference != sheet.widthFollowsPreferredContentSizeWhenEdgeAttached else {
              return
            }

            sheet.animateChanges {
              sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = preference
            }
          }
        }.onPreferenceChange(PreferredCornerRadiusPreferenceKey.self) { preference in
          if let sheet = self.viewController?.sheetPresentationController {
            guard preference != sheet.preferredCornerRadius else {
              return
            }

            sheet.animateChanges {
              sheet.preferredCornerRadius = preference
            }
          }
        }.onPreferenceChange(DismissDisabledPreferenceKey.self) { [self] preference in
          dismissDisabled = preference
        }
    }

    private func resetItemBinding() {
      parent.item = nil
    }

    private func handleDismissal() {
      parent.onDismiss?()
    }

    private func resetItemBindingAndHandleDismissal() {
      parent.item = nil
      parent.onDismiss?()
    }

    // MARK: UIAdaptivePresentationControllerDelegate

    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
      !dismissDisabled
    }

    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
      self.resetItemBindingAndHandleDismissal()
    }
  }
}

fileprivate struct PresentationWatcherViewModifier: ViewModifier {
  @Environment(\.presentationMode)
  @Binding
  private var presentationMode

  let presentationModeChanged: (Bool) -> Void

  func body(content: Content) -> some View {
    content
      .onAppear {
        presentationModeChanged(presentationMode.isPresented)
      }
      .onDisappear {
        presentationModeChanged(presentationMode.isPresented)
      }
  }
}
