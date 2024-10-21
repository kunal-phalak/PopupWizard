import SwiftUI

@MainActor
public class PopupManager: ObservableObject {
    /// Indicates whether a popup is currently presented.
    @Published public var isPopupPresented: Bool = false
    /// Indicates the navigation direction for transitions.
    @Published public var isForward: Bool = true
    /// Stack of popup steps being presented.
    @Published public private(set) var viewStack: [PopupStep] = []
    /// Current transition applied to popup views.
    @Published public private(set) var viewTransition: AnyTransition = .identity

    /// Indicates if the current view is the first in the stack.
    @Published public private(set) var isFirstInStack: Bool = true
    /// Indicates if the current view is the last in the stack.
    @Published public private(set) var isLastInStack: Bool = true

    /// Internal stack sequence for managing popup steps.
    private var sequenceStack: [PopupStep] = []
    /// Current index in the sequence stack.
    public private(set) var currentSequenceIndex: Int = 0

    /// Initializes the PopupManager.
    public init() {}

    /// Determines the transition based on navigation direction.
    private func transitionForDirection() -> AnyTransition {
        isForward
            ? .asymmetric(
                insertion: .move(edge: .trailing).combined(with: .blurReplaceC),
                removal: .move(edge: .leading).combined(with: .blurReplaceC)
              )
            : .asymmetric(
                insertion: .move(edge: .leading).combined(with: .blurReplaceC),
                removal: .move(edge: .trailing).combined(with: .blurReplaceC)
              )
    }

    /// Resets the transition to default.
    private func resetTransition() {
        viewTransition = .opacity
    }

    /// Sets a custom transition for the popup views.
    private func setTransition() {
        viewTransition = .opacity.combined(with: .blurReplaceC)
    }

    /// Sets the sequence of popup steps.
    /// - Parameter steps: An array of `PopupStep` instances.
    public func setSequence(_ steps: [PopupStep]) {
        sequenceStack = steps
        currentSequenceIndex = 0
    }

    /// Presents the popup with the first step in the sequence.
    public func showPopup() {
        guard !sequenceStack.isEmpty else {
            print("Error: Sequence is empty. Call setSequence before showPopup.")
            return
        }

        let firstStep = sequenceStack[0]
        viewStack.removeAll()
        setTransition()

        withAnimation(Constants.ANIMATION) {
            viewStack.append(firstStep)
            isPopupPresented = true
        }

        currentSequenceIndex = 1
        updateStackPosition()
    }

    /// Dismisses the popup.
    public func dismissPopup() {
        withAnimation(Constants.ANIMATION) {
            viewStack.removeAll()
            resetTransition()
            isPopupPresented = false
        }
        currentSequenceIndex = 0
        updateStackPosition()
        print("Dismissed popup.")
    }

    /// Navigates to the next step in the popup sequence.
    public func navigateNext() {
        guard currentSequenceIndex < sequenceStack.count else {
            print("End of sequence reached.")
            dismissPopup()
            return
        }

        let nextStep = sequenceStack[currentSequenceIndex]

        isForward = true
        setTransition()
        withAnimation(Constants.ANIMATION.speed(0.9)) {
            viewStack.append(nextStep)
        }

        currentSequenceIndex += 1
        updateStackPosition()
    }

    /// Navigates back to the previous step in the popup sequence.
    public func navigateBack() {
        guard viewStack.count > 1 else {
            dismissPopup()
            return
        }

        isForward = false
        setTransition()
        withAnimation(Constants.ANIMATION.speed(0.9)) {
            _ = viewStack.popLast()
        }

        currentSequenceIndex -= 1
        updateStackPosition()
    }

    /// Updates the stack position indicators.
    private func updateStackPosition() {
        withAnimation(Constants.ANIMATION) {
            isFirstInStack = currentSequenceIndex <= 1
            isLastInStack = currentSequenceIndex >= sequenceStack.count
        }
    }

    /// Dismisses the popup with a custom animation.
    public func dismissPopupWithAnimation() {
        let animationDuration = Constants.ANIMATION_DURATION
        withAnimation(.easeInOut(duration: animationDuration)) {
            isPopupPresented = false
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
            self.dismissPopup()
        }
    }
}
