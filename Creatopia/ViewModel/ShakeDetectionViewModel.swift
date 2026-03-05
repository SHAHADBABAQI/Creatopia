//
//  ShakeDetectionViewModel.swift
//  Creatopia
//
//  Created by shahad khaled on 16/09/1447 AH.
//

import SwiftUI
import UIKit

// MARK: - Single source of truth for shake detection
// Import this once — used by both Shake.swift and AfterShake.swift

final class ShakeUIView: UIView {
    var onShake: (() -> Void)?

    override var canBecomeFirstResponder: Bool { true }

    override func didMoveToWindow() {
        super.didMoveToWindow()
        becomeFirstResponder()
    }

    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake { onShake?() }
    }
}

struct ShakeRepresentable: UIViewRepresentable {
    let onShake: () -> Void

    func makeUIView(context: Context) -> UIView {
        let view = ShakeUIView()
        view.onShake = onShake
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}

struct ShakeDetector: ViewModifier {
    let onShake: () -> Void

    func body(content: Content) -> some View {
        content.background(ShakeRepresentable(onShake: onShake))
    }
}

// Convenience extension so call sites read naturally:
// .onShake { ... }
extension View {
    func onShake(_ action: @escaping () -> Void) -> some View {
        modifier(ShakeDetector(onShake: action))
    }
}
