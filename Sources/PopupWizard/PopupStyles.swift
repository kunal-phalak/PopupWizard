import SwiftUI

/// Defines the padding style for a popup section.
public struct SectionStyle {
    /// Padding applied to the section.
    public var padding: EdgeInsets

    /// Initializes with uniform padding.
    /// - Parameter padding: The uniform padding value.
    public init(padding: CGFloat = 24) {
        self.padding = EdgeInsets(
            top: padding,
            leading: padding,
            bottom: padding,
            trailing: padding
        )
    }

    /// Initializes with specific EdgeInsets.
    /// - Parameter padding: The EdgeInsets to apply.
    public init(padding: EdgeInsets) {
        self.padding = padding
    }
}

/// Defines the styling for the popup, including background color, corner radius, padding, and section styles.
public struct PopupStyles {
    /// Background color of the popup.
    public var backgroundColor: Color
    /// Optional background image for the popup.
    public var backgroundImage: AnyView?
    /// Corner radius of the popup.
    public var cornerRadius: CGFloat
    /// Padding around the popup content.
    public var padding: EdgeInsets

    /// Padding styles for header, content, and footer sections.
    public var headerStyle: SectionStyle?
    public var contentStyle: SectionStyle?
    public var footerStyle: SectionStyle?

    /// Initializes with uniform padding and optional background image.
    public init(
        backgroundColor: Color = .white,
        backgroundImage: AnyView? = nil,  // Add backgroundImage parameter
        cornerRadius: CGFloat = 16,
        padding: CGFloat = 16,
        headerStyle: SectionStyle? = nil,
        contentStyle: SectionStyle? = nil,
        footerStyle: SectionStyle? = nil
    ) {
        self.backgroundColor = backgroundColor
        self.backgroundImage = backgroundImage // Initialize backgroundImage
        self.cornerRadius = cornerRadius
        self.padding = EdgeInsets(
            top: padding,
            leading: padding,
            bottom: padding,
            trailing: padding
        )
        self.headerStyle = headerStyle
        self.contentStyle = contentStyle
        self.footerStyle = footerStyle
    }
    
    /// Initializes with specific EdgeInsets padding.
    public init(
        backgroundColor: Color = .white,
        backgroundImage: AnyView? = nil,  // Add backgroundImage parameter
        cornerRadius: CGFloat = 16,
        padding: EdgeInsets,
        headerStyle: SectionStyle? = nil,
        contentStyle: SectionStyle? = nil,
        footerStyle: SectionStyle? = nil
    ) {
        self.backgroundColor = backgroundColor
        self.backgroundImage = backgroundImage // Initialize backgroundImage
        self.cornerRadius = cornerRadius
        self.padding = padding
        self.headerStyle = headerStyle
        self.contentStyle = contentStyle
        self.footerStyle = footerStyle
    }
}
