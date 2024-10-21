import SwiftUI

/// ViewModifier that applies a blur effect.
struct BlurEffectView: ViewModifier {
    var radius: CGFloat

    func body(content: Content) -> some View {
        content
            .blur(radius: radius)
    }
}

public extension AnyTransition {
    /// Custom transition combining opacity and blur effects.
    static var blurReplaceC: AnyTransition {
        let insertion = AnyTransition.opacity.combined(with: .modifier(
            active: BlurEffectView(radius: 6),
            identity: BlurEffectView(radius: 0)
        ))
        let removal = AnyTransition.opacity.combined(with: .modifier(
            active: BlurEffectView(radius: 6),
            identity: BlurEffectView(radius: 0)
        ))
        return .asymmetric(insertion: insertion, removal: removal)
    }
}
