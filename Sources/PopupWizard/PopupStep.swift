import SwiftUI

/// Represents a single step in the popup sequence.
public struct PopupStep {
    public let header: AnyView
    public let content: AnyView
    public let footer: AnyView

    /// Initializes a new PopupStep with type-erased views.
    /// - Parameters:
    ///   - header: A closure that returns the header view.
    ///   - content: A closure that returns the content view.
    ///   - footer: A closure that returns the footer view.
    public init<Header: View, Content: View, Footer: View>(
        header: @escaping () -> Header,
        content: @escaping () -> Content,
        footer: @escaping () -> Footer
    ) {
        self.header = AnyView(header())
        self.content = AnyView(content())
        self.footer = AnyView(footer())
    }
}
