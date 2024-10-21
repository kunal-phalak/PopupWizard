import SwiftUI

/// Custom Header
public struct CustomHeader: View {
    public let title: String

    public init(title: String) {
        self.title = title
    }

    public var body: some View {
        HStack {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
            Spacer()
            // Optional: Add a close button here if desired
        }
        .padding()
        .background(Color.blue)
    }
}

/// Custom Footer
public struct CustomFooter: View {
    public var isFirstStep: Bool
    public var isLastStep: Bool
    public var onNext: () -> Void
    public var onBack: () -> Void

    public init(isFirstStep: Bool, isLastStep: Bool, onNext: @escaping () -> Void, onBack: @escaping () -> Void) {
        self.isFirstStep = isFirstStep
        self.isLastStep = isLastStep
        self.onNext = onNext
        self.onBack = onBack
    }

    public var body: some View {
        HStack {
            if !isFirstStep {
                Button(action: {
                    onBack()
                }) {
                    Text("Back")
                        .foregroundColor(.blue)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                }
            }

            Button(action: {
                onNext()
            }) {
                Text(isLastStep ? "Finish" : "Next")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
        }
    }
}
