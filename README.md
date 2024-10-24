# PopupWizard

A SwiftUI experiment with popups and gestures - built while learning iOS development!

## About This Project
This is a learning project I created while exploring SwiftUI's capabilities with gestures and animations. It's a popup/modal system that supports multi-step flows with gesture-based interactions.

## What I Learned
- SwiftUI's gesture system
- Animation and transition APIs
- State management with ObservableObject
- Building custom view modifiers
- Creating reusable components

## Features

- 🎯 Gesture-based interactions
- 🔄 Multi-step navigation
- 📱 Basic responsive design
- 🎨 Customizable styling
- 💨 SwiftUI animations

## Example Usage

```swift
import SwiftUI
import PopupWizard

struct ContentView: View {
    @StateObject private var popupManager = PopupManager()

    var body: some View {
        VStack {
            Button("Show Popup") {
                setupSteps()
                popupManager.showPopup()
            }
        }
        .popupWizard(
            popupManager: popupManager,
            styles: PopupStyles(
                backgroundColor: .white,
                cornerRadius: 40
            )
        )
    }

    private func setupSteps() {
        let steps = [
            PopupStep(
                header: { Text("Step 1") },
                content: { Text("Content") },
                footer: { Text("Next") }
            ),
            // Add more steps...
        ]
        popupManager.setSequence(steps)
    }
}
```

## Requirements
- iOS 17.0+
- SwiftUI

## Note
This is a learning project and might not be suitable for production use. Feel free to explore, learn from it, or build upon it for your own learning journey!
