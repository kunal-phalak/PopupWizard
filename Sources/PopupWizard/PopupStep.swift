import SwiftUI

/// Represents a single step in the popup sequence.
public struct PopupStep {
    public let header: AnyView?
    public let content: AnyView
    public let footer: AnyView?

    /// Initializes a new PopupStep with type-erased views.
    /// - Parameters:
    ///   - header: A closure that returns the header view. Defaults to nil.
    ///   - content: A closure that returns the content view.
    ///   - footer: A closure that returns the footer view. Defaults to nil.
    public init<Content: View>(
        header: (() -> any View)? = nil,
        content: @escaping () -> Content,
        footer: (() -> any View)? = nil
    ) {
        self.header = header.map { AnyView($0()) }
        self.content = AnyView(content())
        self.footer = footer.map { AnyView($0()) }
    }

}
