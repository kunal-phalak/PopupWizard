import SwiftUI

/// Container view for the popup, handling layout and gestures.
public struct PopupContainer: View {
    @ObservedObject private var popupManager: PopupManager
//    private let header: (String) -> Header
//    private let footer: () -> Footer
    private let styles: PopupStyles
    
    @State private var initialAnimationCompleted = false
    @State private var offset: CGSize = .zero
    @State private var backgroundOpacity: Double = 0
    
    /// Initializes the PopupContainer.
    /// - Parameters:
    ///   - popupManager: The manager handling popup state.
    ///   - header: Closure to generate the header view.
    ///   - footer: Closure to generate the footer view.
    ///   - styles: Styles applied to the popup.
    public init(
        popupManager: PopupManager,
//        @ViewBuilder header: @escaping (String) -> Header,
//        @ViewBuilder footer: @escaping () -> Footer,
        styles: PopupStyles
    ) {
        self.popupManager = popupManager
//        self.header = header
//        self.footer = footer
        self.styles = styles
    }
    
    @State private var dragValue = 0.0
    
    public var body: some View {
        GeometryReader { geometry in
            let popupHeight = geometry.size.height * 0.75 // 75% of screen height
            let dismissThreshold = popupHeight * 0.5 // 50% of popup height

            ZStack {
                // Background overlay
                Color(.systemFill)
                    .ignoresSafeArea()
                    .opacity(backgroundOpacity)
                    .animation(Constants.ANIMATION, value: popupManager.isPopupPresented)
                    .onTapGesture {
                        popupManager.dismissPopupWithAnimation()
                    }
                
                // Popup Content
                VStack {
                    Spacer()
                    
                    if let currentStep = popupManager.viewStack.last {
                        VStack {
                            // Header Section
                            HStack {
                                if let lastView = popupManager.viewStack.last {
                                    currentStep.header
                                        .transition(.opacity)
                                        .clipShape(
                                            UnevenRoundedRectangle(cornerRadii: .init(topLeading: styles.cornerRadius, topTrailing: styles.cornerRadius), style: .continuous)
                                        )
                                }
                            }
                            .geometryGroup()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(styles.headerStyle?.padding ?? .init(top:0, leading: 0, bottom: 0, trailing: 0))
                            
                            // Content Section
                            VStack {
                                currentStep.content
                                    .transition(popupManager.viewTransition)
                            }
                            .padding(styles.contentStyle?.padding ?? .init())
                            .clipped()
                            .geometryGroup()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            // Footer Section
                            // Footer with navigation buttons
                            CustomFooter(
                                isFirstStep: popupManager.isFirstInStack,
                                isLastStep: popupManager.isLastInStack,
                                onNext: {
                                    if popupManager.isLastInStack {
                                        popupManager.dismissPopup()
                                    } else {
                                        popupManager.navigateNext()
                                    }
                                },
                                onBack: {
                                    popupManager.navigateBack()
                                }
                            )
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(styles.footerStyle?.padding ?? .init())
                        }
                        .padding(styles.padding)
                        .background(
                            RoundedRectangle(cornerRadius: styles.cornerRadius, style: .continuous)
                                .fill(styles.backgroundColor)
                                .shadow(color: Color(.black).opacity(0.08), radius: 3, x: 0, y: -3)
                        )
                        .padding(geometry.safeAreaInsets.bottom / 3)
                        .clipped()
                        .clipShape(
                            RoundedRectangle(cornerRadius: styles.cornerRadius, style: .continuous)
                        )
                        .containerRelativeFrame(.vertical, alignment: .bottom)
                        .offset(y: popupManager.isPopupPresented && initialAnimationCompleted ? offset.height : geometry.size.height + offset.height)
                    }
                }
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            withAnimation(Constants.ANIMATION) {
                                if value.translation.height > 0 {
                                    offset = value.translation
                                    backgroundOpacity = 1 - Double(offset.height / 200)
                                }
                            }
                        }
                        .onEnded { value in
                            // Calculate the popup height and the dismiss threshold (75% of popup height)
//                            let popupHeight = geometry.size.height // Adjusted to 75% of full screen height
//                            let dismissThreshold = popupHeight * 0.9
                            
                            dragValue = value.translation.height
                            
                            // If the user dragged more than 75% of the popup height, dismiss the popup
                            if value.translation.height >  dismissThreshold {
                                withAnimation(.smooth) {
                                    backgroundOpacity = 0
                                }
                                popupManager.dismissPopupWithAnimation()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    offset = .zero
                                    backgroundOpacity = 1
                                }
                            } else {
                                withAnimation(Constants.ANIMATION) {
                                    offset = .zero
                                    backgroundOpacity = 1
                                }
                            }
                        }
                )
            }
            .onAppear {
                withAnimation(Constants.ANIMATION) {
                    backgroundOpacity = 1
                }
                withAnimation(Constants.ANIMATION) {
                    initialAnimationCompleted = true
                }
            }
        }
    }
}
