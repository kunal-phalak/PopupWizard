import SwiftUI

/// Container view for the popup, handling layout and gestures.
public struct PopupContainer: View {
    @ObservedObject private var popupManager: PopupManager
    private let styles: PopupStyles
    
    @State private var initialAnimationCompleted = false
    @State private var offset: CGSize = .zero
    @State private var backgroundOpacity: Double = 0
        
    /// Initializes the PopupContainer.
    /// - Parameters:
    ///   - popupManager: The manager handling popup state.
    ///   - styles: Styles applied to the popup.
    public init(
        popupManager: PopupManager,
        styles: PopupStyles
    ) {
        self.popupManager = popupManager
        self.styles = styles
    }
    
    public var body: some View {
        GeometryReader { geometry in
            let popupHeight = geometry.size.height * 0.75 // 75% of screen height
            let dismissThreshold = popupHeight * 0.25 // 50% of popup height
            
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
                    
                    ZStack {
                        VStack {
                            // Header Section
                            if let lastView = popupManager.viewStack.last {
                                if (lastView.header != nil) {
                                    HStack {
                                        lastView.header
                                            .transition(.opacity)
                                    }
                                    .geometryGroup()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(styles.headerStyle?.padding ?? .init(top: 0, leading: 0, bottom: 0, trailing: 0))
                                }
                            }
                            
                            // Content Section
                            VStack {
                                if let lastView = popupManager.viewStack.last {
                                    lastView.content
                                        .padding(styles.contentStyle?.padding ?? EdgeInsets())
                                        .transition(.blurReplace)
                                }
                            }
                            .padding(styles.contentStyle?.padding ?? .init())
                            .clipped()
                            .geometryGroup()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            // Footer Section
                            HStack {
                                if let lastView = popupManager.viewStack.last {
                                    lastView.footer
                                        .transition(.opacity)
                                }
                            }
                            .geometryGroup()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(styles.footerStyle?.padding ?? .init())
                        }
                        .padding(styles.padding)
                        .geometryGroup()
                    }
                    .background(
                        RoundedRectangle(cornerRadius: styles.cornerRadius, style: .continuous)
                            .fill(styles.backgroundColor.opacity(1)) // Use opacity to see through to the image
                            .shadow(color: Color(.black).opacity(0.08), radius: 3, x: 0, y: -3)
                    )
                    .frame(width: geometry.size.width * 0.9) // Adjust the width of the popup content
                    .padding(geometry.safeAreaInsets.bottom / 3)
                    .clipped()
                    .clipShape(
                        RoundedRectangle(cornerRadius: styles.cornerRadius, style: .continuous)
                    )
                    .offset(y: popupManager.isPopupPresented && initialAnimationCompleted ? offset.height : geometry.size.height + offset.height)
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
                            if value.translation.height > dismissThreshold {
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
