import SwiftUI

/// ViewModifier that attaches a popup to a view.
public struct PopupWizard: ViewModifier {
    @ObservedObject var popupManager: PopupManager
    
//    var globalHeader: AnyView?
    
    let stylesProvider: PopupStyles

    public func body(content: Content) -> some View {
        ZStack {
            content
                .zIndex(0)

            if popupManager.isPopupPresented || popupManager.viewStack.isEmpty == false {
                PopupContainer(
                    popupManager: popupManager,
                    styles: stylesProvider
                )
                .zIndex(1)
                .allowsHitTesting(popupManager.isPopupPresented)
                .transition(popupManager.viewTransition)
            }
        }
    }
}


public extension View {
    /// Attaches a popup wizard to the view.
    /// - Parameters:
    ///   - popupManager: The manager handling popup state.
    ///   - styles: Styles applied to the popup.
    /// - Returns: A view with the popup attached.
    func popupWizard(
        popupManager: PopupManager,
        styles: PopupStyles = PopupStyles()
    ) -> some View {
        self.modifier(PopupWizard(
            popupManager: popupManager,
            stylesProvider: styles
        ))
    }
}
